import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/network_providers.dart';
import 'package:mytech_egundem_case/features/home/data/home_repository.dart';

part 'home_providers.g.dart';

@riverpod
Future<HomeRepository> homeRepository(Ref ref) async {
  final api = await ref.read(apiClientProvider.future);
  return HomeRepository(api);
}
