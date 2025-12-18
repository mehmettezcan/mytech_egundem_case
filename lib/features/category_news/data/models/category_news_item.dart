class CategoryNewsItem {
  final String id;
  final String title;
  final String content;
  final String imageUrl;

  final String categoryId;
  final String sourceId;
  final String sourceProfilePictureUrl;
  final String sourceTitle;
  final String sourceName;

  final DateTime publishedAt;

  final bool isSaved;
  final bool isLatest;
  final bool isPopular;

  const CategoryNewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.categoryId,
    required this.sourceId,
    required this.sourceProfilePictureUrl,
    required this.sourceTitle,
    required this.sourceName,
    required this.publishedAt,
    required this.isSaved,
    required this.isLatest,
    required this.isPopular,
  });

  factory CategoryNewsItem.fromJson(Map<String, dynamic> json) {
    return CategoryNewsItem(
      id: json['_id'] as String,
      title: json['_title'] as String? ?? '',
      content: json['_content'] as String? ?? '',
      imageUrl: json['_imageUrl'] as String? ?? '',
      categoryId: json['_categoryId'] as String? ?? '',
      sourceId: json['_sourceId'] as String? ?? '',
      sourceProfilePictureUrl: json['_sourceProfilePictureUrl'] as String? ?? '',
      sourceTitle: json['_sourceTitle'] as String? ?? '',
      sourceName: json['_sourceName'] as String? ?? '',
      publishedAt: DateTime.parse(json['_publishedAt'] as String),
      isSaved: json['_isSaved'] == true,
      isLatest: json['_isLatest'] == true,
      isPopular: json['_isPopular'] == true,
    );
  }

  CategoryNewsItem copyWith({bool? isSaved}) => CategoryNewsItem(
        id: id,
        title: title,
        content: content,
        imageUrl: imageUrl,
        categoryId: categoryId,
        sourceId: sourceId,
        sourceProfilePictureUrl: sourceProfilePictureUrl,
        sourceTitle: sourceTitle,
        sourceName: sourceName,
        publishedAt: publishedAt,
        isSaved: isSaved ?? this.isSaved,
        isLatest: isLatest,
        isPopular: isPopular,
      );
}
