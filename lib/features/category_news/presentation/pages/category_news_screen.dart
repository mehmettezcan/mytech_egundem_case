import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:mytech_egundem_case/core/widgets/news_card.dart';
import 'package:mytech_egundem_case/features/category_news/data/models/category_news_item.dart';
import 'package:mytech_egundem_case/features/category_news/presentation/controllers/category_news_controller.dart';

class CategoryNewsScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryNewsScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.watch(categoryNewsControllerProvider(categoryId));
    final paging = ctrl.pagingController;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Column(
        children: [
          const _CategoryTabs(),
          const SizedBox(height: 12),
          Expanded(
            child: PagingListener<int, CategoryNewsItem>(
              controller: paging,
              builder: (context, state, fetchNextPage) => PagedListView<int, CategoryNewsItem>(
                padding: const EdgeInsets.all(8),
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<CategoryNewsItem>(
                  itemBuilder: (context, item, index) {
                    return NewsCard(
                      item: item,
                      onSave: () => ctrl.toggleSave(item),
                    );
                  },
                  firstPageProgressIndicatorBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  newPageProgressIndicatorBuilder: (_) =>
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  noItemsFoundIndicatorBuilder: (_) =>
                      const Center(
                        child: Text(
                          'Haber bulunamadı',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  firstPageErrorIndicatorBuilder: (_) =>
                      const Center(
                        child: Text(
                          'Yüklenemedi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryTabData(
        label: 'Son Dakika',
        icon: Icons.local_fire_department,
        color: const Color(0xFFEF4444),
      ),
      _CategoryTabData(
        label: 'Gündem',
        icon: Icons.newspaper,
        color: const Color(0xFF6B7280),
      ),
      _CategoryTabData(
        label: 'Spor',
        icon: Icons.sports_soccer,
        color: const Color(0xFF10B981),
      ),
      _CategoryTabData(
        label: 'Finans',
        icon: Icons.trending_up,
        color: const Color(0xFF3B82F6),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.map((cat) => _CategoryTabButton(data: cat)).toList(),
    );
  }
}

class _CategoryTabData {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryTabData({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class _CategoryTabButton extends StatelessWidget {
  final _CategoryTabData data;

  const _CategoryTabButton({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(data.icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
