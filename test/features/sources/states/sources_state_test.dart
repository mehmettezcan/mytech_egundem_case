import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/features/sources/data/models/news_source.dart';
import 'package:mytech_egundem_case/features/sources/states/sources_state.dart';

void main() {
  group('SourcesState', () {
    test('should have default values for search and isSaving', () {
      // Arrange
      const sources = <NewsSource>[];
      const followedIds = <String>{};

      // Act
      const state = SourcesState(
        sources: sources,
        followedIds: followedIds,
      );

      // Assert
      expect(state.search, isEmpty);
      expect(state.isSaving, isFalse);
      expect(state.sources, equals(sources));
      expect(state.followedIds, equals(followedIds));
    });

    test('copyWith should update sources', () {
      // Arrange
      const state = SourcesState(
        sources: [],
        followedIds: {},
      );
      final newSource = NewsSource(
        id: 'src1',
        name: 'Source 1',
        description: 'Description',
        imageUrl: 'https://test.com/image.jpg',
        categoryId: 'cat1',
        categoryTitle: 'Category',
        isFollowed: false,
      );

      // Act
      final newState = state.copyWith(sources: [newSource]);

      // Assert
      expect(newState.sources.length, equals(1));
      expect(newState.sources.first.id, equals('src1'));
      expect(newState.followedIds, equals(state.followedIds));
    });

    test('copyWith should update followedIds', () {
      // Arrange
      const state = SourcesState(
        sources: [],
        followedIds: {},
      );
      final newFollowedIds = {'src1', 'src2'};

      // Act
      final newState = state.copyWith(followedIds: newFollowedIds);

      // Assert
      expect(newState.followedIds, equals(newFollowedIds));
      expect(newState.sources, equals(state.sources));
    });

    test('copyWith should update search', () {
      // Arrange
      const state = SourcesState(
        sources: [],
        followedIds: {},
      );

      // Act
      final newState = state.copyWith(search: 'test query');

      // Assert
      expect(newState.search, equals('test query'));
      expect(newState.sources, equals(state.sources));
    });

    test('copyWith should update isSaving', () {
      // Arrange
      const state = SourcesState(
        sources: [],
        followedIds: {},
      );

      // Act
      final newState = state.copyWith(isSaving: true);

      // Assert
      expect(newState.isSaving, isTrue);
      expect(newState.sources, equals(state.sources));
    });

    test('copyWith should preserve other values when updating one field', () {
      // Arrange
      final source = NewsSource(
        id: 'src1',
        name: 'Source 1',
        description: 'Description',
        imageUrl: 'https://test.com/image.jpg',
        categoryId: 'cat1',
        categoryTitle: 'Category',
        isFollowed: true,
      );
      final state = SourcesState(
        sources: [source],
        followedIds: {'src1'},
        search: 'test',
        isSaving: true,
      );

      // Act
      final newState = state.copyWith(search: 'new search');

      // Assert
      expect(newState.search, equals('new search'));
      expect(newState.sources, equals(state.sources));
      expect(newState.followedIds, equals(state.followedIds));
      expect(newState.isSaving, equals(state.isSaving));
    });
  });
}


