import '../../../data/model/response/nearby_photos_response.dart';

class HomeState {
  final bool isLoading;
  final List<PhotoData> photos;
  final bool isTracking;
  final bool isCameraLockedOnUser;
  final double? userLatitude;
  final double? userLongitude;
  final double? cameraLatitude;
  final double? cameraLongitude;

  HomeState({
    this.isLoading = false,
    this.photos = const [],
    this.isTracking = false,
    this.isCameraLockedOnUser = false,
    this.userLatitude,
    this.userLongitude,
    this.cameraLatitude,
    this.cameraLongitude,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PhotoData>? photos,
    bool? isTracking,
    bool? isCameraLockedOnUser,
    double? userLatitude,
    double? userLongitude,
    double? cameraLatitude,
    double? cameraLongitude,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      isTracking: isTracking ?? this.isTracking,
      isCameraLockedOnUser: isCameraLockedOnUser ?? this.isCameraLockedOnUser,
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