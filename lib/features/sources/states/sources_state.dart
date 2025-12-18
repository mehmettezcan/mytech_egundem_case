
import 'package:mytech_egundem_case/features/sources/data/models/news_source.dart';

class SourcesState {
  final List<NewsSource> sources;
  final Set<String> followedIds;
  final String search;
  final bool isSaving;

  const SourcesState({
    required this.sources,
    required this.followedIds,
    this.search = '',
    this.isSaving = false,
  });

  SourcesState copyWith({
    List<NewsSource>? sources,
    Set<String>? followedIds,
    String? search,
    bool? isSaving,
  }) {
    return SourcesState(
      sources: sources ?? this.sources,
      followedIds: followedIds ?? this.followedIds,
      search: search ?? this.search,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
