import 'package:picple/core/util/date_time_utils.dart';

class NearbyPhotosData {
  final String address;
  final PhotoData centerPhoto;
  final List<PhotoData> nearbyPhotos;

  NearbyPhotosData({
    required this.address,
    required this.centerPhoto,
    required this.nearbyPhotos,
  });

  factory NearbyPhotosData.fromJson(Map<String, dynamic> json) {
    return NearbyPhotosData(
      address: json['address'],
      centerPhoto: PhotoData.fromJson(json['centerPhoto']),
      nearbyPhotos: List<PhotoData>.from(
        json['nearbyPhotos'].map((x) => PhotoData.fromJson(x)),
      ),
    );
  }
}

class PhotoData {
  final int id;
  final String title;
  final String imgUrl;
  final String description;
  final String nickname;
  final String profileImgUrl;
  final int likeCount;
  final bool isLiked;
  final String address;
  final String createdAt;

  String get formattedTime => formatPostedTimeFromString(createdAt);

  PhotoData({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.description,
    required this.nickname,
    required this.profileImgUrl,
    required this.likeCount,
    required this.isLiked,
    required this.address,
    required this.createdAt,
  });

  factory PhotoData.fromJson(Map<String, dynamic> json) {
    return PhotoData(
      id: json['id'],
      title: json['title'],
      imgUrl: json['imgUrl'],
      description: json['description'],
      nickname: json['nickname'],
      profileImgUrl: json['profileImgUrl'],
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      address: json['address'],
      createdAt: json['createdAt'],
    );
  }
}