import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/core/di/cache_providers.dart';
import 'package:mytech_egundem_case/features/home/di/home_providers.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:mytech_egundem_case/features/home/states/home_state.dart';

final homeControllerProvider =
    NotifierProvider<HomeController, AsyncValue<HomeState>>(HomeController.new);

class HomeController extends Notifier<AsyncValue<HomeState>> {
  static const int page = 1;
  static const int pageSize = 10;
  static const int popularLimit = 10;

  @override
  AsyncValue<HomeState> build() {
    _loadLatest();
    return const AsyncLoading();
  }

  Future<void> _loadLatest() async {
    await load(isLatest: true, forYou: false);
  }

  Future<void> load({required bool isLatest, required bool forYou}) async {
    try {
      final repo = await ref.read(homeRepositoryProvider.future);

      final categories = await repo.getCategoriesWithNews(
        page: page,
        pageSize: pageSize,
        isLatest: isLatest,
        forYou: forYou,
      );

      final cache = await ref.read(popularNewsCacheProvider.future);
      final cachedPopular = cache.getIfValid();

      final popular = cachedPopular ?? _extractPopular(categories);
      if (cachedPopular == null && popular.isNotEmpty) {
        await cache.save(popular);
      }

      state = AsyncData(HomeState(popular: popular, categories: categories));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<NewsItem> _extractPopular(List<CategoryWithNews> categories) {
    final allNews = categories.expand((c) => c.news).toList();

    final seen = <String>{};
    final popular = <NewsItem>[];

    for (final n in allNews) {
      if (n.isPopular != true) continue;
      if (seen.add(n.id)) popular.add(n);
    }

    popular.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    if (popular.length > popularLimit) {
      return popular.take(popularLimit).toList();
    }
    return popular;
  }

  Future<void> toggleSave(NewsItem item) async {
    final cur = state.value;
    if (cur == null) return;

    final nextSaved = !item.isSaved;

    List updateNewsList(List<NewsItem> list) =>
        list
            .map((n) => n.id == item.id ? n.copyWith(isSaved: nextSaved) : n)
            .toList();

    final updatedCategories =
        cur.categories.map((cwn) {
          final updated = updateNewsList(cwn.news);
          return CategoryWithNews(
            category: cwn.category,
            news: updated.cast<NewsItem>(),
          );
        }).toList();

    final updatedPopular = updateNewsList(cur.popular) as List<NewsItem>;

    state = AsyncData(
      cur.copyWith(popular: updatedPopular, categories: updatedCategories),
    );

    try {
      final repo = await ref.read(homeRepositoryProvider.future);

      repo.toggleSave(newsId: item.id, shouldSave: nextSaved);
    } catch (_) {
      final rolledCategories = cur.categories;
      final rolledPopular = cur.popular;
      state = AsyncData(
        cur.copyWith(popular: rolledPopular, categories: rolledCategories),
      );
    }
  }
}
