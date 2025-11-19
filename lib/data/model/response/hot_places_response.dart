class HotPlacesData {
  final List<HotPlace> hotPlaces;

  HotPlacesData({required this.hotPlaces});

  factory HotPlacesData.fromJson(Map<String, dynamic> json) {
    return HotPlacesData(
      hotPlaces: (json['hotplaces'] as List<dynamic>? ?? [])
          .map((item) => HotPlace.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HotPlace {
  final int order;
  final String locationLabel;
  final int photoCnt;
  final double latitude;
  final double longitude;
  final String imgUrl;

  HotPlace({
    required this.order,
    required this.locationLabel,
    required this.photoCnt,
    required this.latitude,
    required this.longitude,
    required this.imgUrl,
  });

  factory HotPlace.fromJson(Map<String, dynamic> json) {
    return HotPlace(
      order: json['order'] ?? 0,
      locationLabel: json['locationLabel'] ?? '',
      photoCnt: json['photoCnt'] ?? 0,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      imgUrl: json['imgUrl'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
