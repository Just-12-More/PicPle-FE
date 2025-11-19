import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:picple/data/model/response/tag_response.dart';
import 'package:picple/data/repository/tag_repository.dart';
import 'package:picple/presentation/upload/provider/upload_contract.dart';

import '../../../core/util/image_utils.dart';
import '../../../data/repository/photo_repository.dart';
import '../../../data/service_providers.dart';

final uploadStateProvider = NotifierProvider.autoDispose<UploadNotifier, UploadState>(() => UploadNotifier());
final uploadEffectProvider = StateProvider.autoDispose<UploadEffect?>((ref) => null);

class UploadNotifier extends AutoDisposeNotifier<UploadState> {
  late final PhotoRepository _photoRepository;
  late final TagRepository _tagRepository;

  @override
  UploadState build() {
    _photoRepository = ref.watch(photoRepositoryProvider);
    _tagRepository = ref.watch(tagRepositoryProvider);
    Future.microtask(() => _fetchTags());
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
    final originalFile = state.photo;

    if (originalFile == null || originalFile.path.isEmpty) {
      _showToast("선택된 사진이 없습니다");
      return;
    }

    state = state.copyWith(isUploading: true);

    try {
      final compressedFile = await resizeAndCompressImageFile(file: originalFile);

      final filename = path.basename(compressedFile.path);
      final presignResult = await _photoRepository.postPreSignedUrl(filename);

      if (!presignResult.isSuccess || presignResult.data?.preSignedUrl == null) {
        _showToast("Pre-signed URL 발급 실패: ${presignResult.error?.message ?? 'Unknown error'}");
        return;
      }

      final preSignedUrl = presignResult.data!.preSignedUrl;
      final fileImgUrl = presignResult.data!.key;

      final uploadSuccess = await _photoRepository.uploadFileToPreSignedUrl(
        compressedFile,
        preSignedUrl,
      );

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
        state.selectedTagIds.toList(),
      );

      if (uploadResult.isSuccess) {
        ref.read(uploadEffectProvider.notifier).state = UploadSuccess(uploadResult.data!);
      } else {
        _showToast("메타데이터 저장 실패: ${uploadResult.error?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      _showToast("오류 발생: $e");
    } finally {
      state = state.copyWith(isUploading: false);
    }
  }

  Future<void> _fetchTags() async {
    try {
      final response = await _tagRepository.getTags();
      if (response.isSuccess && response.data != null) {
        final TagResponse data = response.data!;
        state = state.copyWith(
          nounTags: data.nouns,
          adjectiveTags: data.adjectives,
        );
      } else {
        _showToast('태그 정보를 가져오지 못했습니다.');
      }
    } catch (e) {
      _showToast('태그 조회 중 오류가 발생했습니다: $e');
    }
  }

  void toggleTag(int tagId) {
    final updated = Set<int>.from(state.selectedTagIds);
    if (updated.contains(tagId)) {
      updated.remove(tagId);
    } else {
      updated.add(tagId);
    }
    state = state.copyWith(selectedTagIds: updated);
  }

  void _showToast(String message) {
    ref.read(uploadEffectProvider.notifier).state = ShowToast(message);
  }
}
