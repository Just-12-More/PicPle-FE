import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:picple/presentation/upload/provider/upload_contract.dart';

import '../../../data/repository/photo_repository.dart';
import '../../../data/service_providers.dart';

final uploadStateProvider = NotifierProvider<UploadNotifier, UploadState>(() => UploadNotifier());
final uploadEffectProvider = StateProvider<UploadEffect?>((ref) => null);

class UploadNotifier extends Notifier<UploadState> {
  late final PhotoRepository _photoRepository;

  @override
  UploadState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    return UploadState();
  }

  void setPhoto(File file) {
    state = state.copyWith(photo: file);
  }

  Future<void> uploadPhoto(
      String title,
      String description,
      double latitude,
      double longitude,
      ) async {
    final file = state.photo;

    if (file == null || file.path.isEmpty) {
      _showToast("선택된 사진이 없습니다");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final filename = path.basename(file.path);
      final presignResult = await _photoRepository.postPreSignedUrl(filename);

      if (!presignResult.isSuccess || presignResult.data?.preSignedUrl == null) {
        _showToast("Pre-signed URL 발급 실패: ${presignResult.error?.message ?? 'Unknown error'}");
        return;
      }

      final preSignedUrl = presignResult.data!.preSignedUrl;
      final fileImgUrl = presignResult.data!.key;
      final uploadSuccess = await _photoRepository.uploadFileToPreSignedUrl(file, preSignedUrl);

      if (!uploadSuccess) {
        _showToast("사진 업로드 실패 (S3)");
        return;
      }

      final uploadResult = await _photoRepository.uploadPhoto(
        fileImgUrl,
        title,
        description,
        latitude,
        longitude,
      );

      if (uploadResult.isSuccess) {
        ref.read(uploadEffectProvider.notifier).state = NavigateBack();
      } else {
        _showToast("메타데이터 저장 실패: ${uploadResult.error?.message ?? 'Unknown error'}");
      }

    } catch (e) {
      _showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _showToast(String message) {
    ref.read(uploadEffectProvider.notifier).state = ShowToast(message);
  }
}