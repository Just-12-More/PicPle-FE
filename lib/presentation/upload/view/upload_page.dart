import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/picple_colors.dart';
import '../../theme/picple_typography.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UploadScreen();
  }
}

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _photo;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get _isFormValid =>
      _photo != null &&
          _titleController.text.trim().isNotEmpty &&
          _descriptionController.text.trim().isNotEmpty;

  void _updateState() => setState(() {});

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
      });
    }
  }

  Future<void> _checkCameraPermissionAndTakePhoto() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _takePhoto();
    } else if (status.isDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        _takePhoto();
      } else {
        _showPermissionDeniedDialog();
      }
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('권한 필요'),
        content: const Text('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(_updateState);
    _descriptionController.addListener(_updateState);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCameraPermissionAndTakePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PicpleColors.white,
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
        child: SingleChildScrollView(
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
                child: _photo != null
                    ? Image.file(
                  _photo!,
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
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ElevatedButton(
            onPressed: _isFormValid ? () {
              log('사진 업로드');
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
}
