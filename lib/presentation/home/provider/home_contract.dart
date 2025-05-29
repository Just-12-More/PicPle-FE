import '../../../data/model/response/nearby_photos_response.dart';

class HomeState {
  final bool isLoading;
  final List<PhotoData> photos;
  final bool isTracking;
  final double? userLatitude;
  final double? userLongitude;
  final double? cameraLatitude;
  final double? cameraLongitude;

  HomeState({
    this.isLoading = false,
    this.photos = const [],
    this.isTracking = false,
    this.userLatitude,
    this.userLongitude,
    this.cameraLatitude,
    this.cameraLongitude,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PhotoData>? photos,
    bool? isTracking,
    double? userLatitude,
    double? userLongitude,
    double? cameraLatitude,
    double? cameraLongitude,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      isTracking: isTracking ?? this.isTracking,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      cameraLatitude: cameraLatitude ?? this.cameraLatitude,
      cameraLongitude: cameraLongitude ?? this.cameraLongitude,
    );
  }
}

abstract class HomeEffect {}
class ShowToast extends HomeEffect {
  final String message;
  ShowToast(this.message);
}
class MoveCamera extends HomeEffect {
  final double latitude;
  final double longitude;
  MoveCamera(this.latitude, this.longitude);
}