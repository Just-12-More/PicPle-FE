class RecommendPhotosResponse {
  final List<RecommendPhotoData> photos;

  const RecommendPhotosResponse({required this.photos});

  factory RecommendPhotosResponse.fromList(List<dynamic> list) {
    return RecommendPhotosResponse(
      photos: list
          .map((item) => RecommendPhotoData.fromJson(
                Map<String, dynamic>.from(item as Map),
              ))
          .toList(),
    );
  }
}

class RecommendPhotoData {
  final int id;
  final String imgUrl;
  final List<String> tags;

  const RecommendPhotoData({
    required this.id,
    required this.imgUrl,
    required this.tags,
  });

  factory RecommendPhotoData.fromJson(Map<String, dynamic> json) {
    final tagsJson = json['tags'];
    return RecommendPhotoData(
      id: _toInt(json['id']),
      imgUrl: json['imgUrl'] ?? '',
      tags: tagsJson is List
          ? tagsJson.map((e) => e.toString()).toList()
          : const <String>[],
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
