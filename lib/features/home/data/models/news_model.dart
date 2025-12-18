class NewsItem {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String categoryId;
  final String sourceId;
  final String sourceTitle;
  final String sourceProfilePictureUrl;
  final DateTime publishedAt;

  final bool isSaved;
  final bool isLatest;
  final bool isPopular;

  final String sourceName;
  final String categoryName;

  const NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.categoryId,
    required this.sourceId,
    required this.sourceTitle,
    required this.sourceProfilePictureUrl,
    required this.publishedAt,
    required this.isSaved,
    required this.isLatest,
    required this.isPopular,
    required this.sourceName,
    required this.categoryName,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      categoryId: json['categoryId'] as String,
      sourceId: json['sourceId'] as String? ?? '',
      sourceTitle: json['sourceTitle'] as String? ?? '',
      sourceProfilePictureUrl: json['sourceProfilePictureUrl'] as String? ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      isSaved: json['isSaved'] == true,
      isLatest: json['isLatest'] == true,
      isPopular: json['isPopular'] == true,
      sourceName: json['sourceName'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
    );
  }

  NewsItem copyWith({bool? isSaved}) {
    return NewsItem(
      id: id,
      title: title,
      content: content,
      imageUrl: imageUrl,
      categoryId: categoryId,
      sourceId: sourceId,
      sourceTitle: sourceTitle,
      sourceProfilePictureUrl: sourceProfilePictureUrl,
      publishedAt: publishedAt,
      isSaved: isSaved ?? this.isSaved,
      isLatest: isLatest,
      isPopular: isPopular,
      sourceName: sourceName,
      categoryName: categoryName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'imageUrl': imageUrl,
    'categoryId': categoryId,
    'sourceId': sourceId,
    'sourceProfilePictureUrl': sourceProfilePictureUrl,
    'sourceTitle': sourceTitle,
    'publishedAt': publishedAt.toIso8601String(),
    'isSaved': isSaved,
    'isLatest': isLatest,
    'isPopular': isPopular,
    'sourceName': sourceName,
    'categoryName': categoryName,
  };
}
