import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:mytech_egundem_case/core/di/storage_providers.dart';
import 'package:mytech_egundem_case/core/widgets/news_card.dart';
import 'package:mytech_egundem_case/features/category_news/presentation/pages/category_news_screen.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:mytech_egundem_case/features/home/presentation/controllers/home_controller.dart';
import 'package:mytech_egundem_case/features/twitter/presentation/screens/twitter_screen.dart';
import 'package:mytech_egundem_case/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int tabIndex = 0; // 0: Son Haberler, 1: Sana Özel, 2: Twitter, 3: YouTube

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(homeControllerProvider);
    final ctrl = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Icon(Icons.menu, color: Colors.white),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 12),
          GestureDetector(
            child: const Icon(Icons.account_circle_rounded, color: Colors.white),
            onDoubleTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF232629),
                  title: const Text(
                    'Çıkış Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Çıkış yapmak istediğinizden emin misiniz?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'İptal',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Çıkış Yap',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                try {
                  final tokenStorage = await ref.read(tokenStorageProvider.future);
                  await tokenStorage.clear();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteGenerator.loginScreen,
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Logout hatası: $e')),
                    );
                  }
                }
              }
            },
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Tabs(
              index: tabIndex,
              onChanged: (i) async {
                setState(() => tabIndex = i);
                if (i == 0) await ctrl.load(isLatest: true, forYou: false);
                if (i == 1) await ctrl.load(isLatest: false, forYou: true);
              },
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (tabIndex == 2) {
                    return const TwitterScreen();
                  }

                  if (tabIndex == 3) {
                    return const Center(
                      child: Text(
                        'YouTube (coming soon)',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return async.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(e.toString())),
                    data: (st) {
                      return ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          if (st.popular.isNotEmpty) ...[
                            const _SectionTitle(title: 'Popüler Haberler'),
                            const SizedBox(height: 10),
                            _PopularCarousel(
                              items: st.popular,
                              onSave: (item) => ctrl.toggleSave(item),
                            ),
                            const SizedBox(height: 18),
                          ],

                          for (final cwn in st.categories) ...[
                            _CategorySection(
                              cwn: cwn,
                              onSave: (item) => ctrl.toggleSave(item),
                              onMore: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CategoryNewsScreen(
                                          categoryId: cwn.category.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _Tabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _Tabs({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = const ['Son Haberler', 'Sana Özel', 'Twitter', 'YouTube'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabs[i],
                    style: TextStyle(
                      color:
                          active
                              ? const Color(0xFFEF4444)
                              : Colors.white.withOpacity(0.7),
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 3,
                    decoration: BoxDecoration(
                      color:
                          active ? const Color(0xFFEF4444) : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _PopularCarousel extends StatefulWidget {
  final List<NewsItem> items;
  final void Function(NewsItem item) onSave;

  const _PopularCarousel({required this.items, required this.onSave});

  @override
  State<_PopularCarousel> createState() => _PopularCarouselState();
}

class _PopularCarouselState extends State<_PopularCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _PopularCard(
                  item: widget.items[index],
                  onSave: () => widget.onSave(widget.items[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.items.length,
            (index) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index == _currentPage
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFEF4444).withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularCard extends StatelessWidget {
  final NewsItem item;
  final VoidCallback onSave;

  const _PopularCard({required this.item, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  item.imageUrl.isNotEmpty
                      ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                Container(color: const Color(0xFF101B2D)),
                      )
                      : Container(color: const Color(0xFF101B2D)),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            top: 12,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                item.categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              onPressed: onSave,
              icon: Icon(
                item.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: const Color(0xFFEF4444),
                size: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item.sourceProfilePictureUrl.isNotEmpty)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(item.sourceProfilePictureUrl),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFEF4444),
                        ),
                        child: const Icon(
                          Icons.newspaper,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        item.sourceTitle.isNotEmpty
                            ? item.sourceTitle
                            : item.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final CategoryWithNews cwn;
  final void Function(NewsItem item) onSave;
  final VoidCallback onMore;

  const _CategorySection({
    required this.cwn,
    required this.onSave,
    required this.onMore,
  });

  Color _hexToColor(String hex) {
    final v = hex.replaceAll('#', '');
    final val = int.parse(v.length == 6 ? 'FF$v' : v, radix: 16);
    return Color(val);
  }

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(cwn.category.colorCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                cwn.category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: onMore,
              child: Text('Daha Fazla Göster', style: TextStyle(color: color)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in cwn.news)
          NewsCard(item: item, onSave: () => onSave(item), color: color),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: onMore,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Daha Fazla Göster'),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.description,
                label: 'Anasayfa',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.explore,
                label: 'e-gündem',
                isActive: false,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.alarm,
                label: '',
                isActive: false,
                isCenter: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.bookmark_border,
                label: 'Kaydedilenler',
                isActive: false,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.location_on,
                label: 'Yerel',
                isActive: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isCenter = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.alarm, color: Colors.white, size: 24),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isActive
                    ? const Color(0xFFEF4444)
                    : Colors.white.withOpacity(0.7),
            size: 24,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:
                    isActive
                        ? const Color(0xFFEF4444)
                        : Colors.white.withOpacity(0.7),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
