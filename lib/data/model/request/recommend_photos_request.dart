class RecommendPhotosRequest {
  final List<int> tagIds;

  const RecommendPhotosRequest({required this.tagIds});

  Map<String, dynamic> toJson() => {
        'tagIds': tagIds,
      };
}
