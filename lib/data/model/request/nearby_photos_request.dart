class NearbyPhotosRequest {
  final double latitude;
  final double longitude;

  NearbyPhotosRequest({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}