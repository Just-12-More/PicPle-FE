import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    state = state.copyWith(isLoading: true);

    try {
      final result = await _photoRepository.uploadPhoto(
        state.photo?.path ?? '',
        title,
        description,
        latitude,
        longitude,
      );

      if (result.isSuccess) {
        _showToast("Upload successful");
      } else {
        _showToast("Upload failed: ${result.error?.message ?? 'Unknown error'}");
      }
    } catch (e) {
      _showToast("Error occurred: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _showToast(String message) {
    ref.read(uploadEffectProvider.notifier).state = ShowToast(message);
  }
}