class UploadPhotoRequest {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String photoUrl;

  UploadPhotoRequest({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrl': photoUrl,
    };
  }
}