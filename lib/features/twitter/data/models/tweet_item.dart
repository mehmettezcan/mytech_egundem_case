class TweetItem {
  final String id;
  final String accountId;
  final String accountName;
  final String accountImageUrl;
  final String content;
  final DateTime createdAt;
  final bool isPopular;

  const TweetItem({
    required this.id,
    required this.accountId,
    required this.accountName,
    required this.accountImageUrl,
    required this.content,
    required this.createdAt,
    required this.isPopular,
  });

  factory TweetItem.fromJson(Map<String, dynamic> json) {
    return TweetItem(
      id: json['id'] as String,
      accountId: json['accountId'] as String? ?? '',
      accountName: json['accountName'] as String? ?? '',
      accountImageUrl: json['accountImageUrl'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPopular: json['isPopular'] == true,
    );
  }
}
