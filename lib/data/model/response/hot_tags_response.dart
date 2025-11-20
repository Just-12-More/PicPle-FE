class HotTagsResponse {
  final List<HotTag> tags;

  const HotTagsResponse({
    required this.tags,
  });

  factory HotTagsResponse.fromList(List<dynamic> jsonList) {
    return HotTagsResponse(
      tags: jsonList
          .map((item) => HotTag.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HotTag {
  final int id;
  final String name;
  final String tagType;
  final int count;

  const HotTag({
    required this.id,
    required this.name,
    required this.tagType,
    required this.count,
  });

  factory HotTag.fromJson(Map<String, dynamic> json) {
    return HotTag(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      tagType: json['tagType'] ?? '',
      count: _toInt(json['count']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
