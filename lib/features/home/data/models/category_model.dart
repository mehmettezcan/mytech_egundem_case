class NewsCategory {
  final String id;
  final String name;
  final String description;
  final String colorCode;
  final String imageUrl;

  const NewsCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.colorCode,
    required this.imageUrl,
  });

  factory NewsCategory.fromJson(Map<String, dynamic> json) {
    return NewsCategory(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      colorCode: json['colorCode'] as String? ?? '#3B82F6',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}
