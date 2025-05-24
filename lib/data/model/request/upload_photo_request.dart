class UploadPhotoRequest {
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String imageUrl;

  UploadPhotoRequest({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
    };
  }
}