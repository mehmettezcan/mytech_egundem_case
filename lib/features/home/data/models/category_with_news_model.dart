

import 'package:mytech_egundem_case/features/home/data/models/category_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';

class CategoryWithNews {
  final NewsCategory category;
  final List<NewsItem> news;

  const CategoryWithNews({
    required this.category,
    required this.news,
  });

  factory CategoryWithNews.fromJson(Map<String, dynamic> json) {
    return CategoryWithNews(
      category: NewsCategory.fromJson(json['category'] as Map<String, dynamic>),
      news: (json['news'] as List)
          .map((e) => NewsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
