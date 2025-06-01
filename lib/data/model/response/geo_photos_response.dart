import 'nearby_photos_response.dart';

class GeoPhotosData {
  final List<PhotoData> photos;

  GeoPhotosData({
    required this.photos,
  });

  factory GeoPhotosData.fromJson(Map<String, dynamic> json) {
    return GeoPhotosData(
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => PhotoData.fromJson(photo as Map<String, dynamic>))
          .toList(),
    );
  }
}