import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/network_providers.dart';
import 'package:mytech_egundem_case/core/di/storage_providers.dart';
import 'package:mytech_egundem_case/features/auth/data/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
Future<AuthRepository> authRepository(Ref ref) async {
  final api = await ref.read(apiClientProvider.future);
  final tokenStorage = await ref.watch(tokenStorageProvider.future);
  return AuthRepository(api, tokenStorage);
}
