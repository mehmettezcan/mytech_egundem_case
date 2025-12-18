import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/app_providers.dart';
import 'package:mytech_egundem_case/core/storage/token_storage.dart';

part 'storage_providers.g.dart';

@riverpod
Future<TokenStorage> tokenStorage(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return TokenStorage(prefs);
}
