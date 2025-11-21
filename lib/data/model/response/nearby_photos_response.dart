import 'package:picple/core/util/date_time_utils.dart';

import 'tag_response.dart';

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
      address: json['address'] ?? '',
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
  final double latitude;
  final double longitude;
  final String createdAt;
  final List<TagItem> tags;

  String get formattedTime => formatPostedTimeFromString(createdAt);

  const PhotoData({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.description,
    required this.nickname,
    required this.profileImgUrl,
    required this.likeCount,
    required this.isLiked,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    this.tags = const <TagItem>[],
  });

  PhotoData copyWith({
    int? id,
    String? title,
    String? imgUrl,
    String? description,
    String? nickname,
    String? profileImgUrl,
    int? likeCount,
    bool? isLiked,
    String? address,
    double? latitude,
    double? longitude,
    String? createdAt,
    List<TagItem>? tags,
  }) {
    return PhotoData(
      id: id ?? this.id,
      title: title ?? this.title,
      imgUrl: imgUrl ?? this.imgUrl,
      description: description ?? this.description,
      nickname: nickname ?? this.nickname,
      profileImgUrl: profileImgUrl ?? this.profileImgUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  factory PhotoData.fromJson(Map<String, dynamic> json) {
    List<TagItem> parsedTags = const <TagItem>[];
    final dynamic tagsJson = json['tags'];
    if (tagsJson is List) {
      parsedTags = tagsJson
          .whereType<Map<String, dynamic>>()
          .map(TagItem.fromJson)
          .toList();
    }

    return PhotoData(
      id: json['id'],
      title: json['title'],
      imgUrl: json['imgUrl'] ?? '',
      description: json['description'],
      nickname: json['nickname'] ?? '',
      profileImgUrl: json['profileImgUrl'] ?? '',
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      createdAt: json['createdAt'],
      tags: parsedTags,
    );
  }
}
