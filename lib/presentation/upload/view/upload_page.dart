import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../../../core/service/flutter_image_picker.dart';
import '../../../core/util/permission_utils.dart';
import '../../../data/model/response/tag_response.dart';
import '../../../routes.dart';
import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';
import '../provider/upload_contract.dart';
import '../provider/upload_provider.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UploadScreen();
  }
}

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _checkCameraPermissionAndTakePhoto() async {
    final cameraGranted = await requestPermission(
      context: context,
      permission: Permission.camera,
      errorMessage: '카메라 권한이 필요합니다.',
    );

    if (!cameraGranted) return;

    await _openCamera();
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() => setState(() { }));
    _descriptionController.addListener(() => setState(() { }));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialPhotoRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadStateProvider);
    final photoFile = uploadState.photo;
    final isUploading = uploadState.isUploading;
    final hasPhoto = photoFile != null && photoFile.existsSync();
    final hasSelectedAdjectiveTag = uploadState.adjectiveTags.any(
      (tag) => uploadState.selectedTagIds.contains(tag.id),
    );
    final hasSelectedNounTag = uploadState.nounTags.any(
      (tag) => uploadState.selectedTagIds.contains(tag.id),
    );
    final isFormValid = _isFormValid(
      hasPhoto,
      isUploading,
      hasSelectedAdjectiveTag,
      hasSelectedNounTag,
    );
    final previewKey = hasPhoto
        ? ValueKey(
            '${photoFile.path}_${photoFile.lastModifiedSync().millisecondsSinceEpoch}',
          )
        : null;
    ref.listen<UploadEffect?>(uploadEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case UploadSuccess():
          context.pop(
            UploadCompletedResult(photo: next.photo, tagIds: next.tagIds),
          );
          break;
        case ShowToast():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.message)),
          );
          break;
      }

      ref.read(uploadEffectProvider.notifier).state = null;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
        scrolledUnderElevation: 0,
        title: Text(
          '사진 올리기',
          style: PicpleTypography.title1.copyWith(
            color: PicpleColors.black
          )
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: PicpleColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPhotoPreview(hasPhoto, photoFile, previewKey),
                        const SizedBox(height: 16),
                        _buildTitleField(),
                        _buildDescriptionField(),
                      ],
                    ),
                  ),
                  if (uploadState.nounTags.isNotEmpty)
                    Column(
                      children: [
                        Divider(color: PicpleColors.gray3, height: 1, thickness: 1),
                        _buildTagSelectorSection(
                          title: '어디에서?',
                          tags: uploadState.nounTags,
                          selectedTagIds: uploadState.selectedTagIds,
                          onTagToggle: (id) =>
                              ref.read(uploadStateProvider.notifier).toggleTag(id),
                        ),
                      ],
                    ),
                  if (uploadState.adjectiveTags.isNotEmpty)
                    Column(
                      children: [
                        Divider(color: PicpleColors.gray3, height: 1, thickness: 1),
                        _buildTagSelectorSection(
                          title: '어떤 느낌?',
                          tags: uploadState.adjectiveTags,
                          selectedTagIds: uploadState.selectedTagIds,
                          onTagToggle: (id) =>
                              ref.read(uploadStateProvider.notifier).toggleTag(id),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            if (isUploading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black45,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ElevatedButton(
            onPressed: isFormValid ? () async {
              final title = _titleController.text.trim();
              final description = _descriptionController.text.trim();

              _handleUpload(context, ref, title, description);
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: PicpleColors.primary1,
              disabledBackgroundColor: PicpleColors.gray4,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              ),
              child: Text(
                '등록하기',
              style: PicpleTypography.body1SemiBold.copyWith(
                color: PicpleColors.white,
              )
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagSelectorSection({
    required String title,
    required List<TagItem> tags,
    required Set<int> selectedTagIds,
    required void Function(int tagId) onTagToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/icons/ic_tag.svg",
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: PicpleTypography.title2.copyWith(
                  color: PicpleColors.primary1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((tag) {
              final isSelected = selectedTagIds.contains(tag.id);

              return GestureDetector(
                onTap: () => onTagToggle(tag.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? PicpleColors.primary1 : PicpleColors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : PicpleColors.gray3,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                        : null,
                  ),
                  child: Text(
                    tag.name,
                    style: PicpleTypography.body2SemiBold.copyWith(
                      color: isSelected ? PicpleColors.white : PicpleColors.gray5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPhotoPreview(bool hasPhoto, File? photoFile, Key? previewKey) {
    return AspectRatio(
      aspectRatio: 1,
      child: hasPhoto
          ? Image.file(
              photoFile!,
              key: previewKey,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            )
          : GestureDetector(
              onTap: _checkCameraPermissionAndTakePhoto,
              child: Container(
                color: PicpleColors.gray2,
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      style: PicpleTypography.head2.copyWith(color: PicpleColors.black),
      decoration: InputDecoration(
        hintText: '제목을 입력하세요',
        border: InputBorder.none,
        hintStyle: PicpleTypography.head2.copyWith(
          color: PicpleColors.gray5,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      style: PicpleTypography.body1.copyWith(color: PicpleColors.black),
      decoration: InputDecoration(
        hintText: '간단한 설명을 입력해주세요',
        border: InputBorder.none,
        hintStyle: PicpleTypography.body1.copyWith(
          color: PicpleColors.gray4,
        ),
      ),
      maxLines: 5,
    );
  }

  bool _isFormValid(
    bool hasPhoto,
    bool isUploading,
    bool hasSelectedAdjectiveTag,
    bool hasSelectedNounTag,
  ) {
    if (isUploading) return false;

    return hasPhoto &&
        _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        hasSelectedAdjectiveTag &&
        hasSelectedNounTag;
  }

  Future<void> _handleUpload(BuildContext context, WidgetRef ref, String title, String description) async {
    final messenger = ScaffoldMessenger.of(context);

    final granted = await requestPermission(
      context: context,
      permission: Permission.locationWhenInUse,
      errorMessage: '위치 권한이 필요합니다.',
    );
    if (!granted) return;

    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('위치 정보를 가져올 수 없습니다: $e')),
      );
      return;
    }

    await ref.read(uploadStateProvider.notifier).uploadPhoto(
      title,
      description,
      position.latitude,
      position.longitude,
    );
  }

  Future<void> _handleInitialPhotoRequest() async {
    final restored = await _restoreLostPhotoIfAvailable();
    if (!restored) {
      await _checkCameraPermissionAndTakePhoto();
    }
  }

  Future<bool> _restoreLostPhotoIfAvailable() async {
    final file = await FlutterImagePicker.retrieveLostImage();
    if (file == null) {
      return false;
    }
    await _onPhotoReady(file);
    return true;
  }

  Future<void> _openCamera() async {
    final file = await context.push<File?>(Routes.camera.path);
    if (file == null) {
      return;
    }
    final editedFile = await _editPhotoWithProImageEditor(file);
    if (editedFile == null) {
      return;
    }
    await _onPhotoReady(editedFile);
  }

  Future<File?> _editPhotoWithProImageEditor(File file) async {
    if (!mounted) return null;

    Uint8List? editedBytes;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (editorContext) {
          return ProImageEditor.file(
            file,
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (bytes) async {
                editedBytes = bytes;
              },
              onCloseEditor: (_) {
                Navigator.of(editorContext).maybePop(editedBytes);
              },
            ),
          );
        },
      ),
    );

    if (editedBytes == null) {
      return null;
    }

    await file.writeAsBytes(editedBytes!, flush: true);
    PaintingBinding.instance.imageCache.evict(FileImage(file));
    return file;
  }

  Future<void> _onPhotoReady(File file) async {
    try {
      await Gal.putImage(file.path);
    } catch (error, stackTrace) {
      log('Failed to save photo to gallery: $error');
      log('$stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('갤러리에 사진을 저장하지 못했습니다.'),
            ),
          );
      }
    }

    if (!mounted) return;
    ref.read(uploadStateProvider.notifier).setPhoto(file);
  }
}
