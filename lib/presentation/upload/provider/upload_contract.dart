import 'dart:io';

class UploadState {
  final bool isLoading;
  final File? photo;

  UploadState({
    this.isLoading = false,
    this.photo,
  });

  UploadState copyWith({
    bool? isLoading,
    File? photo,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      photo: photo ?? this.photo,
    );
  }
}

abstract class UploadEffect { }
class NavigateBack extends UploadEffect {}
class ShowToast extends UploadEffect {
  final String message;
  ShowToast(this.message);
}
