import 'dart:io';

import '../../../data/model/response/nearby_photos_response.dart';

class UploadState {
  final bool isUploading;
  final File? photo;

  UploadState({
    this.isUploading = false,
    this.photo,
  });

  UploadState copyWith({
    bool? isUploading,
    File? photo,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
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
