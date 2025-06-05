import 'package:picple/data/model/response/nearby_photos_response.dart';

class PhotoListState {
  final bool isInitialized;
  final String address;
  final List<PhotoData> photos;

  PhotoListState({
    this.isInitialized = false,
    this.address = '',
    this.photos = const [],
  });

  PhotoListState copyWith({
    bool? isInitialized,
    String? address,
    List<PhotoData>? photos,
  }) {
    return PhotoListState(
      isInitialized: isInitialized ?? this.isInitialized,
      address: address ?? this.address,
      photos: photos ?? this.photos,
    );
  }
}

abstract class PhotoListEffect { }
class ShowToast extends PhotoListEffect {
  final String message;
  ShowToast(this.message);
}
