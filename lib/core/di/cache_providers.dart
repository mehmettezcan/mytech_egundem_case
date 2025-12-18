import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/cache/popular_news_cache.dart';
import 'package:mytech_egundem_case/core/di/app_providers.dart';

part 'cache_providers.g.dart';

@riverpod
Future<PopularNewsCache> popularNewsCache(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return PopularNewsCache(prefs);
}


