class TagResponse {
  final List<TagItem> nouns;
  final List<TagItem> adjectives;

  TagResponse({
    required this.nouns,
    required this.adjectives,
  });

  factory TagResponse.fromJson(Map<String, dynamic> json) {
    final nounsJson = json['nouns'] as List<dynamic>? ?? [];
    final adjectivesJson = json['adjectives'] as List<dynamic>? ?? [];

    return TagResponse(
      nouns: nounsJson
          .map((item) => TagItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      adjectives: adjectivesJson
          .map((item) => TagItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TagItem {
  final int id;
  final String name;
  final String tagType;

  TagItem({
    required this.id,
    required this.name,
    required this.tagType,
  });

  factory TagItem.fromJson(Map<String, dynamic> json) {
    return TagItem(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      tagType: json['tagType'] ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
