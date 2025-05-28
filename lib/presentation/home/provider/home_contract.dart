import '../../../data/model/response/nearby_photos_response.dart';

class HomeState {
  final bool isLoading;
  final List<PhotoData> photos;
  final bool isTracking;
  final bool isCameraLockedOnUser;
  final double? latitude;
  final double? longitude;

  HomeState({
    this.isLoading = false,
    this.photos = const [],
    this.isTracking = false,
    this.isCameraLockedOnUser = false,
    this.latitude,
    this.longitude,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PhotoData>? photos,
    bool? isTracking,
    bool? isCameraLockedOnUser,
    double? latitude,
    double? longitude,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      photos: photos ?? this.photos,
      isTracking: isTracking ?? this.isTracking,
      isCameraLockedOnUser: isTracking ?? this.isCameraLockedOnUser,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

abstract class HomeEffect {}
class ShowToast extends HomeEffect {
  final String message;
  ShowToast(this.message);
}