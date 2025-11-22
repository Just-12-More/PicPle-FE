class RecommendationPhoto {
  final int id;
  final String imageUrl;
  final List<String> tags;

  const RecommendationPhoto({
    required this.id,
    required this.imageUrl,
    this.tags = const <String>[],
  });
}
