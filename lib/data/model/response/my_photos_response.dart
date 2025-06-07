class MyPhotosData {
  final List<SimplePhotoData> photos;

  MyPhotosData({
    required this.photos,
  });

  factory MyPhotosData.fromJson(Map<String, dynamic> json) {
    return MyPhotosData(
      photos: List<SimplePhotoData>.from(
        json['photos'].map((x) => SimplePhotoData.fromJson(x)),
      ),
    );
  }
}

class SimplePhotoData {
  final int id;
  final String imgUrl;

  const SimplePhotoData({
    required this.id,
    required this.imgUrl,
  });

  factory SimplePhotoData.fromJson(Map<String, dynamic> json) {
    return SimplePhotoData(
      id: json['id'],
      imgUrl: json['imgUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
    };
  }
}