import 'package:picple/data/model/response/nearby_photos_response.dart';

class MyPhotosData {
  final String address;
  final List<PhotoData> photos;

  MyPhotosData({
    required this.address,
    required this.photos,
  });

  factory MyPhotosData.fromJson(Map<String, dynamic> json) {
    return MyPhotosData(
      address: json['address'],
      photos: List<PhotoData>.from(
        json['photos'].map((x) => PhotoData.fromJson(x)),
      ),
    );
  }
}