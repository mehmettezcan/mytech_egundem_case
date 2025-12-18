import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mytech_egundem_case/features/category_news/data/models/category_news_item.dart';
import 'package:mytech_egundem_case/features/category_news/di/category_news_providers.dart';

class CategoryNewsController {
  final Ref ref;
  final String categoryId;

  static const int pageSize = 10;

  late final PagingController<int, CategoryNewsItem> pagingController =
      PagingController<int, CategoryNewsItem>(
        getNextPageKey:
            (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
        fetchPage: (pageKey) => _fetchPage(pageKey),
      );

  CategoryNewsController(this.ref, this.categoryId) {
    ref.onDispose(pagingController.dispose);
  }

  Future<List<CategoryNewsItem>> _fetchPage(int pageKey) async {
    final repo = await ref.read(categoryNewsRepositoryProvider.future);

    final res = await repo.getCategoryNews(
      categoryId: categoryId,
      page: pageKey,
      pageSize: pageSize,
    );

    return res.items;
  }

  Future<void> toggleSave(CategoryNewsItem item) async {
    final repo = await ref.read(categoryNewsRepositoryProvider.future);
    final next = !item.isSaved;

    final state = pagingController.value;
    final pages = state.pages;
    if (pages == null) return;

    int pageIndex = -1;
    int itemIndex = -1;

    for (int i = 0; i < pages.length; i++) {
      final idx = pages[i].indexWhere((x) => x.id == item.id);
      if (idx != -1) {
        pageIndex = i;
        itemIndex = idx;
        break;
      }
    }

    if (pageIndex == -1) return;

    final oldItem = pages[pageIndex][itemIndex];
    final updatedItem = oldItem.copyWith(isSaved: next);

    final newPages =
        pages.map((page) => List<CategoryNewsItem>.from(page)).toList();
    newPages[pageIndex][itemIndex] = updatedItem;

    pagingController.value = state.copyWith(pages: newPages);

    try {
      
      await repo.toggleSave(newsId: item.id, shouldSave: next);
    } catch (_) {
      final rollbackPages =
          pages.map((page) => List<CategoryNewsItem>.from(page)).toList();
      pagingController.value = state.copyWith(pages: rollbackPages);
    }
  }
}

final categoryNewsControllerProvider = Provider.autoDispose
    .family<CategoryNewsController, String>((ref, categoryId) {
      return CategoryNewsController(ref, categoryId);
    });
