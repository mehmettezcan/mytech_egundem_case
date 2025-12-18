class NewsSource {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String categoryId;
  final String categoryTitle;
  final bool isFollowed;

  const NewsSource({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.categoryTitle,
    required this.isFollowed,
  });

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      categoryId: json['sourceCategoryId'] as String,
      categoryTitle: json['sourceCategoryTitle'] as String,
      isFollowed: json['isFollowed'] == true,
    );
  }
}
