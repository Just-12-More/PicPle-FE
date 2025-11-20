class TaggedPhotosResponse {
  final List<TaggedPhoto> photos;

  const TaggedPhotosResponse({
    required this.photos,
  });

  factory TaggedPhotosResponse.fromList(List<dynamic> jsonList) {
    return TaggedPhotosResponse(
      photos: jsonList
          .map((item) => TaggedPhoto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TaggedPhoto {
  final int id;
  final String imgUrl;
  final List<String> tags;

  const TaggedPhoto({
    required this.id,
    required this.imgUrl,
    required this.tags,
  });

  factory TaggedPhoto.fromJson(Map<String, dynamic> json) {
    return TaggedPhoto(
      id: _toInt(json['id']),
      imgUrl: json['imgUrl'] ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((tag) => tag.toString())
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
