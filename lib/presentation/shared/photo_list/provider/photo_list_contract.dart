import 'package:picple/data/model/response/nearby_photos_response.dart';

class PhotoListState {
  final bool isLoading;
  final String address;
  final List<PhotoData> photos;

  PhotoListState({
    this.isLoading = false,
    this.address = '',
    this.photos = const [],
  });

  PhotoListState copyWith({
    bool? isLoading,
    String? address,
    List<PhotoData>? photos,
  }) {
    return PhotoListState(
      isLoading: isLoading ?? this.isLoading,
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
