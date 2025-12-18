import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/features/sources/data/models/news_source.dart';
import 'package:mytech_egundem_case/features/sources/data/source_repository.dart';
import 'package:mytech_egundem_case/features/sources/di/source_providers.dart';
import 'package:mytech_egundem_case/features/sources/presentation/controllers/sources_controller.dart';
import 'package:mytech_egundem_case/features/sources/states/sources_state.dart';

class MockSourceRepository extends Mock implements SourceRepository {}

void main() {
  group('SourcesController', () {
    late MockSourceRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockSourceRepository();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with loading state', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
        ],
      );

      final state = container.read(sourcesControllerProvider);

      // Assert
      expect(state.isLoading, isTrue);
    });

    group('_load', () {
      test('should load sources and extract followed IDs', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: true,
          ),
          NewsSource(
            id: 'src2',
            name: 'Source 2',
            description: 'Description',
            imageUrl: 'https://test.com/image2.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Act
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isTrue);
        final sourcesState = state.value!;
        expect(sourcesState.sources.length, equals(2));
        expect(sourcesState.followedIds, contains('src1'));
        expect(sourcesState.followedIds, isNot(contains('src2')));

        verify(() => mockRepository.getAllSources()).called(greaterThanOrEqualTo(1));
      });

      test('should handle error when loading fails', () async {
        // Arrange
        when(() => mockRepository.getAllSources())
            .thenThrow(Exception('Network error'));

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        // Act - wait for build() to call _load() and complete
        var attempts = 0;
        AsyncValue<SourcesState>? finalState;
        while (attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          finalState = container.read(sourcesControllerProvider);
          if (finalState != null && (finalState.hasValue || finalState.hasError)) break;
          attempts++;
        }

        // Assert
        expect(finalState, isNotNull);
        expect(finalState!.hasError, isTrue, reason: 'State should have error when loading fails');
        expect(finalState.error, isA<Exception>());
      });
    });

    group('toggleFollow', () {
      test('should add source to followedIds when not followed', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        controller.toggleFollow('src1');

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isTrue);
        final sourcesState = state.value!;
        expect(sourcesState.followedIds, contains('src1'));
      });

      test('should remove source from followedIds when followed', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: true,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        controller.toggleFollow('src1');

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isTrue);
        final sourcesState = state.value!;
        expect(sourcesState.followedIds, isNot(contains('src1')));
      });

      test('should not update state when current state is null', () {
        // Arrange
        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Act
        controller.toggleFollow('src1');

        // Assert - state should remain loading or error
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isFalse);
      });
    });

    group('setSearch', () {
      test('should update search query', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        controller.setSearch('test query');

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isTrue);
        final sourcesState = state.value!;
        expect(sourcesState.search, equals('test query'));
      });

      test('should not update state when current state is null', () {
        // Arrange
        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Act
        controller.setSearch('test');

        // Assert - state should remain loading or error
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isFalse);
      });
    });

    group('groupedFiltered', () {
      test('should return grouped sources by category', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category 1',
            isFollowed: false,
          ),
          NewsSource(
            id: 'src2',
            name: 'Source 2',
            description: 'Description',
            imageUrl: 'https://test.com/image2.jpg',
            categoryId: 'cat2',
            categoryTitle: 'Category 2',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        final result = controller.groupedFiltered();

        // Assert
        expect(result.length, equals(2));
        expect(result['Category 1'], isNotNull);
        expect(result['Category 2'], isNotNull);
        expect(result['Category 1']!.length, equals(1));
        expect(result['Category 2']!.length, equals(1));
      });

      test('should filter sources by search query', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
          NewsSource(
            id: 'src2',
            name: 'Other Source',
            description: 'Description',
            imageUrl: 'https://test.com/image2.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Set search query
        controller.setSearch('Source 1');

        // Act
        final result = controller.groupedFiltered();

        // Assert
        expect(result.length, equals(1));
        expect(result['Category'], isNotNull);
        expect(result['Category']!.length, equals(1));
      });

      test('should return empty map when state is null', () {
        // Arrange
        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Act
        final result = controller.groupedFiltered();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('save', () {
      test('should sync followed sources successfully', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: true,
          ),
          NewsSource(
            id: 'src2',
            name: 'Source 2',
            description: 'Description',
            imageUrl: 'https://test.com/image2.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);
        when(() => mockRepository.syncFollowedSources(any()))
            .thenAnswer((_) async => {});

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        await controller.save();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasValue, isTrue);
        final sourcesState = state.value!;
        expect(sourcesState.isSaving, isFalse);

        verify(() => mockRepository.syncFollowedSources(any())).called(1);
      });

      test('should set isSaving to true during save', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);
        when(() => mockRepository.syncFollowedSources(any())).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 50));
        });

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        final future = controller.save();
        
        // Check state during save
        await Future.delayed(const Duration(milliseconds: 10));
        final stateDuringSave = container.read(sourcesControllerProvider);
        expect(stateDuringSave.value?.isSaving, isTrue);

        // Wait for completion
        await future;

        // Assert
        final finalState = container.read(sourcesControllerProvider);
        expect(finalState.value?.isSaving, isFalse);
      });

      test('should handle error when save fails', () async {
        // Arrange
        final sources = [
          NewsSource(
            id: 'src1',
            name: 'Source 1',
            description: 'Description',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            categoryTitle: 'Category',
            isFollowed: false,
          ),
        ];

        when(() => mockRepository.getAllSources()).thenAnswer((_) async => sources);
        when(() => mockRepository.syncFollowedSources(any()))
            .thenThrow(Exception('Save failed'));

        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Wait for initial load
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        await controller.save();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(sourcesControllerProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<Exception>());
      });

      test('should not save when state is null', () async {
        // Arrange
        container = ProviderContainer(
          overrides: [
            sourceRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
          ],
        );

        final controller = container.read(sourcesControllerProvider.notifier);

        // Act
        await controller.save();

        // Assert
        verifyNever(() => mockRepository.syncFollowedSources(any()));
      });
    });
  });
}

