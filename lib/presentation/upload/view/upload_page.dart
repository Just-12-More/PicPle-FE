import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/util/permission_utils.dart';
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
  final ImagePicker _picker = ImagePicker();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get _isFormValid {
    final state = ref.watch(uploadStateProvider);

    return state.photo != null &&
        state.photo!.existsSync() &&
        _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Gal.putImage(pickedFile.path);
      await Future.delayed(const Duration(milliseconds: 300)); // 안전한 딜레이
      if (!mounted) return;
      ref.read(uploadStateProvider.notifier).setPhoto(File(pickedFile.path));
      setState(() {});
    }
  }

  Future<void> _checkCameraPermissionAndTakePhoto() async {
    final granted = await requestPermission(
      context: context,
      permission: Permission.camera,
      errorMessage: '카메라 권한이 필요합니다.',
    );

    if (granted) {
      _takePhoto();
    }
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() => setState(() { }));
    _descriptionController.addListener(() => setState(() { }));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCameraPermissionAndTakePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadStateProvider);
    ref.listen<UploadEffect?>(uploadEffectProvider, (previous, next) {
      if (next == null) return;

      switch (next) {
        case UploadSuccess():
          context.pop(next.photo);
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: PicpleColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 사진 미리보기
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: state.photo != null && state.photo!.existsSync()
                        ? Image.file(
                          state.photo!,
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
                  ),
                  const SizedBox(height: 24),

                  // 제목 입력란
                  TextField(
                    controller: _titleController,
                    style: PicpleTypography.head2.copyWith(
                      color: PicpleColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '제목을 입력하세요',
                      border: InputBorder.none,
                      hintStyle: PicpleTypography.head2.copyWith(
                        color: PicpleColors.gray5,
                      ),
                    ),
                  ),

                  // 설명 입력란
                  TextField(
                    controller: _descriptionController,
                    style: PicpleTypography.body1.copyWith(
                      color: PicpleColors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: '간단한 설명을 입력해주세요',
                      border: InputBorder.none,
                      hintStyle: PicpleTypography.body1.copyWith(
                        color: PicpleColors.gray4,
                      ),
                    ),
                    maxLines: 5,
                  ),
                ],
              ),
            ),

            if (state.isLoading)
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
            onPressed: _isFormValid && !state.isLoading ? () async {
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
}
