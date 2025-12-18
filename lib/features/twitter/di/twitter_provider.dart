import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/network_providers.dart';
import 'package:mytech_egundem_case/features/twitter/data/twitter_repository.dart';

part 'twitter_provider.g.dart';

@riverpod
Future<TwitterRepository> twitterRepository(Ref ref) async {
  final api = await ref.read(apiClientProvider.future);
  return TwitterRepository(api);
}