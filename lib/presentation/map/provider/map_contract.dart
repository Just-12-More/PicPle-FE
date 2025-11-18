import '../../../data/model/response/nearby_photos_response.dart';

class MapState {
  final bool isLoading;
  final List<PhotoData> photos;
  final int zoomLevel;
  final double? userLatitude;
  final double? userLongitude;
  final double? cameraLatitude;
  final double? cameraLongitude;

  MapState({
    this.isLoading = false,
    this.photos = const [],
    this.zoomLevel = 14,
    this.userLatitude,
    this.userLongitude,
    this.cameraLatitude,
    this.cameraLongitude,
  });

  MapState copyWith({
    bool? isLoading,
    List<PhotoData>? photos,
    int ? zoomLevel,
    double? userLatitude,
    double? userLongitude,
    double? cameraLatitude,
    double? cameraLongitude,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      cameraLatitude: cameraLatitude ?? this.cameraLatitude,
      cameraLongitude: cameraLongitude ?? this.cameraLongitude,
    );
  }
}

abstract class HomeEffect {}
class NavigateTo extends HomeEffect {
  final String route;
  NavigateTo(this.route);
}
class ShowToast extends HomeEffect {
  final String message;
  ShowToast(this.message);
}
class MoveCamera extends HomeEffect {
  final double latitude;
  final double longitude;
  MoveCamera(this.latitude, this.longitude);
}