class ProfileData {
  final String nickname;
  final String profileImgUrl;

  ProfileData({
    required this.nickname,
    required this.profileImgUrl,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      nickname: json['nickname'] as String,
      profileImgUrl: json['profileImgUrl'] as String,
    );
  }
} 