import 'nearby_photos_response.dart';

class GeoPhotosData {
  final String address;
  final List<PhotoData> photos;

  GeoPhotosData({
    required this.address,
    required this.photos,
  });

  factory GeoPhotosData.fromJson(Map<String, dynamic> json) {
    return GeoPhotosData(
      address: json['address'] as String,
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => PhotoData.fromJson(photo as Map<String, dynamic>))
          .toList(),
    );
  }
}