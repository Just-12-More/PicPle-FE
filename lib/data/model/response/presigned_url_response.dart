class PreSignedUrlData {
  final String preSignedUrl;
  final String key;

  PreSignedUrlData({
    required this.preSignedUrl,
    required this.key,
  });

  factory PreSignedUrlData.fromJson(Map<String, dynamic> json) {
    return PreSignedUrlData(
      preSignedUrl: json['preSignedUrl'] as String,
      key: json['key'] as String,
    );
  }
}