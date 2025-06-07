class ProfileData {
  final String username;
  final String profilePath;

  ProfileData({
    required this.username,
    required this.profilePath,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      username: json['username'] as String,
      profilePath: json['profilePath'] as String,
    );
  }
} 