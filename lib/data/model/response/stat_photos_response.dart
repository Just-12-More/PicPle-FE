import 'nearby_photos_response.dart';

class StatPhotosData {
  final List<PhotoData> photos;

  const StatPhotosData({
    this.photos = const <PhotoData>[],
  });

  factory StatPhotosData.fromJson(Map<String, dynamic> json) {
    final dynamic rawPhotos = json['photos'];
    final List<dynamic> photosJson =
        rawPhotos is List ? rawPhotos : const <dynamic>[];

    return StatPhotosData(
      photos: photosJson
          .whereType<Map<String, dynamic>>()
          .map(PhotoData.fromJson)
          .toList(),
    );
  }
}
