import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mytech_egundem_case/features/twitter/data/models/tweet_item.dart';
import 'package:mytech_egundem_case/features/twitter/presentation/controllers/tweets_controller.dart';


class TwitterScreen extends ConsumerStatefulWidget {
  const TwitterScreen({super.key});

  @override
  ConsumerState<TwitterScreen> createState() => _TwitterScreenState();
}

class _TwitterScreenState extends ConsumerState<TwitterScreen> {
  TweetFeedType selected = TweetFeedType.popular;

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(tweetsControllerProvider(selected));

    return Column(
      children: [
        const SizedBox(height: 12),
        _Segmented(
          selected: selected,
          onChanged: (v) => setState(() => selected = v),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: PagingListener<int, TweetItem>(
            controller: ctrl.pagingController,
            builder: (context, state, fetchNextPage) => PagedListView<int, TweetItem>(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<TweetItem>(
                itemBuilder: (context, item, index) => _TweetCard(item: item),
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                firstPageErrorIndicatorBuilder: (_) =>
                    const Center(child: Text('Failed to load tweets')),
                noItemsFoundIndicatorBuilder: (_) =>
                    const Center(child: Text('No tweets found')),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Segmented extends StatelessWidget {
  final TweetFeedType selected;
  final ValueChanged<TweetFeedType> onChanged;

  const _Segmented({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isPopular = selected == TweetFeedType.popular;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _PillButton(
            label: 'Popüler',
            active: isPopular,
            onTap: () => onChanged(TweetFeedType.popular),
          ),
          const SizedBox(width: 10),
          _PillButton(
            label: 'Sana Özel',
            active: !isPopular,
            onTap: () => onChanged(TweetFeedType.forYou),
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.grey : const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TweetCard extends StatelessWidget {
  final TweetItem item;
  const _TweetCard({required this.item});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dakika önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    return '${diff.inDays} gün önce';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: item.accountImageUrl.isNotEmpty
                    ? NetworkImage(item.accountImageUrl)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.accountName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                _timeAgo(item.createdAt),
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.content,
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}
