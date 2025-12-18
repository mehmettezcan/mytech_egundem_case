import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/network_providers.dart';
import 'package:mytech_egundem_case/features/category_news/data/category_news_repository.dart';

part 'category_news_providers.g.dart';

@riverpod
Future<CategoryNewsRepository> categoryNewsRepository(Ref ref) async {
  final api = await ref.read(apiClientProvider.future);
  return CategoryNewsRepository(api);
}