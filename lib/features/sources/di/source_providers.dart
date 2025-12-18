import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/network_providers.dart';
import 'package:mytech_egundem_case/features/sources/data/source_repository.dart';

part 'source_providers.g.dart';

@riverpod
Future<SourceRepository> sourceRepository(Ref ref) async {
  final api = await ref.read(apiClientProvider.future);
  return SourceRepository(api);
}