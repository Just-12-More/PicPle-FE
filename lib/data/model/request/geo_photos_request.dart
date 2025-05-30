class GeoPhotosRequest {
  final double latitude;
  final double longitude;
  final double radius;

  GeoPhotosRequest({
    required this.latitude,
    required this.longitude,
    required this.radius
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }
}