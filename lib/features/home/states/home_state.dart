import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';

class HomeState {
  final List<NewsItem> popular;
  final List<CategoryWithNews> categories;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.popular = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<NewsItem>? popular,
    List<CategoryWithNews>? categories,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      popular: popular ?? this.popular,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
