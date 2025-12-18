import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mytech_egundem_case/features/twitter/data/models/tweet_item.dart';
import 'package:mytech_egundem_case/features/twitter/di/twitter_provider.dart';

enum TweetFeedType { popular, forYou }

class TweetsController {
  final Ref ref;
  final TweetFeedType type;

  static const int pageSize = 10;

  late final PagingController<int, TweetItem> pagingController =
      PagingController<int, TweetItem>(
        getNextPageKey: (state) =>
            state.lastPageIsEmpty ? null : state.nextIntPageKey,
        fetchPage: (pageKey) => _fetchPage(pageKey),
      );

  TweetsController(this.ref, this.type) {
    ref.onDispose(pagingController.dispose);
  }

  Future<List<TweetItem>> _fetchPage(int pageKey) async {
    final repo = await ref.read(twitterRepositoryProvider.future);
    final items = await repo.getTweets(
      page: pageKey,
      pageSize: pageSize,
      isPopular: type == TweetFeedType.popular,
    );

    return items;
  }

  void refresh() => pagingController.refresh();
}

final tweetsControllerProvider =
    Provider.autoDispose.family<TweetsController, TweetFeedType>((ref, type) {
  return TweetsController(ref, type);
});
