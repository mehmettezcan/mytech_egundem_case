import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/features/sources/data/models/follow_source_dto.dart';
import 'package:mytech_egundem_case/features/sources/di/source_providers.dart';
import 'package:mytech_egundem_case/features/sources/states/sources_state.dart';

final sourcesControllerProvider =
    NotifierProvider<SourcesController, AsyncValue<SourcesState>>(
        SourcesController.new);

class SourcesController extends Notifier<AsyncValue<SourcesState>> {
  @override
  AsyncValue<SourcesState> build() {
    _load();
    return const AsyncLoading();
  }

  Future<void> _load() async {
    try {
      final repo = await ref.read(sourceRepositoryProvider.future);
      final list = await repo.getAllSources();

      final followed = list
          .where((s) => s.isFollowed)
          .map((s) => s.id)
          .toSet();

      state = AsyncData(
        SourcesState(
          sources: list,
          followedIds: followed,
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void toggleFollow(String sourceId) {
    final cur = state.value;
    if (cur == null) return;

    final next = Set<String>.from(cur.followedIds);
    next.contains(sourceId) ? next.remove(sourceId) : next.add(sourceId);

    state = AsyncData(cur.copyWith(followedIds: next));
  }

  void setSearch(String value) {
    final cur = state.value;
    if (cur == null) return;

    state = AsyncData(cur.copyWith(search: value));
  }

  Map<String, List<dynamic>> groupedFiltered() {
    final cur = state.value;
    if (cur == null) return {};

    final q = cur.search.toLowerCase();

    final filtered = q.isEmpty
        ? cur.sources
        : cur.sources.where((s) => s.name.toLowerCase().contains(q)).toList();

    final map = <String, List<dynamic>>{};
    for (final s in filtered) {
      map.putIfAbsent(s.categoryTitle, () => []).add(s);
    }
    return map;
  }

  Future<void> save() async {
  final cur = state.value;
  if (cur == null) return;

  state = AsyncData(cur.copyWith(isSaving: true));

  try {
    final payload = cur.sources
        .map((s) => FollowSourceDto(
              sourceId: s.id,
              isFollowed: cur.followedIds.contains(s.id),
            ))
        .toList();

   final sourceRepository = await ref.read(sourceRepositoryProvider.future);
   await sourceRepository.syncFollowedSources(payload);

    state = AsyncData(cur.copyWith(isSaving: false));
  } catch (e, st) {
    state = AsyncError(e, st);
  }
}

}
