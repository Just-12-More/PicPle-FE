class GeoPhotosRequest {
  final double latitude;
  final double longitude;
  final double leftTopLatitude;
  final double leftTopLongitude;
  final double rightBottomLatitude;
  final double rightBottomLongitude;

  GeoPhotosRequest({
    required this.latitude,
    required this.longitude,
    required this.leftTopLatitude,
    required this.leftTopLongitude,
    required this.rightBottomLatitude,
    required this.rightBottomLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'leftTopLatitude': leftTopLatitude,
      'leftTopLongitude': leftTopLongitude,
      'rightBottomLatitude': rightBottomLatitude,
      'rightBottomLongitude': rightBottomLongitude,
    };
  }
}