import 'dart:io';

import '../../../data/model/response/nearby_photos_response.dart';

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
class UploadSuccess extends UploadEffect {
  final PhotoData photo;
  UploadSuccess(this.photo);
}
class ShowToast extends UploadEffect {
  final String message;
  ShowToast(this.message);
}
