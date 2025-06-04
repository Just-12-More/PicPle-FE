class PreSignedUrlRequest {
  final String filename;

  PreSignedUrlRequest({
    required this.filename,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
    };
  }
}