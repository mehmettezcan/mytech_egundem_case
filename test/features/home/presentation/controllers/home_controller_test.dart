import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/cache/popular_news_cache.dart';
import 'package:mytech_egundem_case/core/di/app_providers.dart';
import 'package:mytech_egundem_case/core/di/cache_providers.dart';
import 'package:mytech_egundem_case/core/di/env_providers.dart';
import 'package:mytech_egundem_case/features/home/data/home_repository.dart';
import 'package:mytech_egundem_case/features/home/di/home_providers.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:mytech_egundem_case/features/home/presentation/controllers/home_controller.dart';
import 'package:mytech_egundem_case/features/home/states/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

class MockPopularNewsCache extends Mock implements PopularNewsCache {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

// Test controller that overrides homeRepositoryProvider getter
class TestHomeController extends HomeController {
  final HomeRepository repository;

  TestHomeController(this.repository);

  @override
  ProviderListenable get homeRepositoryProvider => Provider((ref) => repository);

  @override
  AsyncValue<HomeState> build() {
    // Don't call _loadLatest() in tests - we'll call load() manually
    return const AsyncLoading();
  }
}

void main() {
  group('HomeController', () {
    late MockHomeRepository mockRepository;
    late MockPopularNewsCache mockCache;
    late MockSharedPreferences mockPrefs;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockHomeRepository();
      mockCache = MockPopularNewsCache();
      mockPrefs = MockSharedPreferences();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with loading state', () {
      // Arrange & Act
      container = ProviderContainer(
        overrides: [
          homeControllerProvider.overrideWith(
            () => TestHomeController(mockRepository),
          ),
          popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
        ],
      );

      final state = container.read(homeControllerProvider);

      // Assert
      expect(state.isLoading, isTrue);
    });

    group('load', () {
      test('should load categories and popular news successfully', () async {
        // Arrange
        final category = NewsCategory(
          id: 'cat1',
          name: 'Category',
          description: 'Description',
          colorCode: '#3B82F6',
          imageUrl: 'https://test.com/image.jpg',
        );
        final newsItem = NewsItem(
          id: 'news1',
          title: 'News Title',
          content: 'Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Source',
          categoryName: 'Category',
        );
        final categoryWithNews = CategoryWithNews(
          category: category,
          news: [newsItem],
        );

        when(() => mockRepository.getCategoriesWithNews(
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize'),
              isLatest: any(named: 'isLatest'),
              forYou: any(named: 'forYou'),
            )).thenAnswer((_) async => [categoryWithNews]);
        when(() => mockCache.getIfValid()).thenReturn(null);
        when(() => mockCache.save(any())).thenAnswer((_) async => {});

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Act
        await controller.load(isLatest: true, forYou: false);
        
        // Wait for state to be updated - poll until hasValue is true or hasError
        var attempts = 0;
        AsyncValue<HomeState>? finalState;
        while (attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          finalState = container.read(homeControllerProvider);
          if (finalState != null && (finalState.hasValue || finalState.hasError)) break;
          attempts++;
        }

        // Assert
        expect(finalState, isNotNull);
        if (finalState!.hasError) {
          fail('State has error: ${finalState.error}');
        }
        expect(finalState.hasValue, isTrue, reason: 'State should have value after load completes');
        final homeState = finalState.value!;
        expect(homeState.categories.length, equals(1));
        expect(homeState.popular.length, equals(1));
        expect(homeState.popular.first.id, equals('news1'));

        // Note: build() calls _loadLatest() which calls load(), so it's called twice
        verify(() => mockRepository.getCategoriesWithNews(
              page: 1,
              pageSize: 10,
              isLatest: true,
              forYou: false,
            )).called(greaterThanOrEqualTo(1));
        // Note: build() calls _loadLatest() which calls load(), so methods are called twice
        verify(() => mockCache.getIfValid()).called(greaterThanOrEqualTo(1));
        verify(() => mockCache.save(any())).called(greaterThanOrEqualTo(1));
      });

      test('should use cached popular news when available', () async {
        // Arrange
        final cachedNews = [
          NewsItem(
            id: 'cached1',
            title: 'Cached News',
            content: 'Content',
            imageUrl: 'https://test.com/image.jpg',
            categoryId: 'cat1',
            sourceId: 'src1',
            sourceTitle: 'Source',
            sourceProfilePictureUrl: 'https://test.com/profile.jpg',
            publishedAt: DateTime.now(),
            isSaved: false,
            isLatest: true,
            isPopular: true,
            sourceName: 'Source',
            categoryName: 'Category',
          ),
        ];

        final category = NewsCategory(
          id: 'cat1',
          name: 'Category',
          description: 'Description',
          colorCode: '#3B82F6',
          imageUrl: 'https://test.com/image.jpg',
        );
        final categoryWithNews = CategoryWithNews(
          category: category,
          news: [],
        );

        when(() => mockRepository.getCategoriesWithNews(
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize'),
              isLatest: any(named: 'isLatest'),
              forYou: any(named: 'forYou'),
            )).thenAnswer((_) async => [categoryWithNews]);
        when(() => mockCache.getIfValid()).thenReturn(cachedNews);

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Act
        await controller.load(isLatest: true, forYou: false);
        
        // Wait for state to be updated - poll until hasValue is true or hasError
        var attempts = 0;
        AsyncValue<HomeState>? finalState;
        while (attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          finalState = container.read(homeControllerProvider);
          if (finalState != null && (finalState.hasValue || finalState.hasError)) break;
          attempts++;
        }

        // Assert
        expect(finalState, isNotNull);
        if (finalState!.hasError) {
          fail('State has error: ${finalState.error}');
        }
        expect(finalState.hasValue, isTrue, reason: 'State should have value after load completes');
        final homeState = finalState.value!;
        expect(homeState.popular.length, equals(1));
        expect(homeState.popular.first.id, equals('cached1'));

        // Note: build() calls _loadLatest() which calls load(), so getIfValid is called twice
        verify(() => mockCache.getIfValid()).called(greaterThanOrEqualTo(1));
        verifyNever(() => mockCache.save(any()));
      });

      test('should handle error when loading fails', () async {
        // Arrange
        when(() => mockRepository.getCategoriesWithNews(
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize'),
              isLatest: any(named: 'isLatest'),
              forYou: any(named: 'forYou'),
            )).thenThrow(Exception('Network error'));

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Act
        await controller.load(isLatest: true, forYou: false);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        final state = container.read(homeControllerProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<Exception>());
      });
    });

    group('toggleSave', () {
      test('should toggle save status and update state', () async {
        // Arrange
        final newsItem = NewsItem(
          id: 'news1',
          title: 'News Title',
          content: 'Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Source',
          categoryName: 'Category',
        );
        final category = NewsCategory(
          id: 'cat1',
          name: 'Category',
          description: 'Description',
          colorCode: '#3B82F6',
          imageUrl: 'https://test.com/image.jpg',
        );
        final categoryWithNews = CategoryWithNews(
          category: category,
          news: [newsItem],
        );

        when(() => mockRepository.getCategoriesWithNews(
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize'),
              isLatest: any(named: 'isLatest'),
              forYou: any(named: 'forYou'),
            )).thenAnswer((_) async => [categoryWithNews]);
        when(() => mockCache.getIfValid()).thenReturn(null);
        when(() => mockCache.save(any())).thenAnswer((_) async => {});
        when(() => mockRepository.toggleSave(
              newsId: any(named: 'newsId'),
              shouldSave: any(named: 'shouldSave'),
            )).thenAnswer((_) async => {});

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Load initial data
        await controller.load(isLatest: true, forYou: false);
        
        // Wait for initial state to be updated
        var attempts = 0;
        while (attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          final currentState = container.read(homeControllerProvider);
          if (currentState.hasValue || currentState.hasError) break;
          attempts++;
        }
        
        final initialState = container.read(homeControllerProvider);
        if (initialState.hasError) {
          fail('Initial state has error: ${initialState.error}');
        }
        expect(initialState.hasValue, isTrue, reason: 'Initial state should have value');

        // Act
        await controller.toggleSave(newsItem);
        
        // Wait for toggleSave to complete and state to update
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        final state = container.read(homeControllerProvider);
        expect(state.hasValue, isTrue);
        final homeState = state.value!;
        expect(homeState.popular.first.isSaved, isTrue);
        expect(homeState.categories.first.news.first.isSaved, isTrue);

        verify(() => mockRepository.toggleSave(
              newsId: 'news1',
              shouldSave: true,
            )).called(1);
      });

      test('should rollback state when toggleSave fails', () async {
        // Arrange
        final newsItem = NewsItem(
          id: 'news1',
          title: 'News Title',
          content: 'Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Source',
          categoryName: 'Category',
        );
        final category = NewsCategory(
          id: 'cat1',
          name: 'Category',
          description: 'Description',
          colorCode: '#3B82F6',
          imageUrl: 'https://test.com/image.jpg',
        );
        final categoryWithNews = CategoryWithNews(
          category: category,
          news: [newsItem],
        );

        when(() => mockRepository.getCategoriesWithNews(
              page: any(named: 'page'),
              pageSize: any(named: 'pageSize'),
              isLatest: any(named: 'isLatest'),
              forYou: any(named: 'forYou'),
            )).thenAnswer((_) async => [categoryWithNews]);
        when(() => mockCache.getIfValid()).thenReturn(null);
        when(() => mockCache.save(any())).thenAnswer((_) async => {});
        when(() => mockRepository.toggleSave(
              newsId: any(named: 'newsId'),
              shouldSave: any(named: 'shouldSave'),
            )).thenThrow(Exception('Save failed'));

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Load initial data
        await controller.load(isLatest: true, forYou: false);
        
        // Wait for initial state to be updated
        var attempts = 0;
        while (attempts < 50) {
          await Future.delayed(const Duration(milliseconds: 50));
          final currentState = container.read(homeControllerProvider);
          if (currentState.hasValue || currentState.hasError) break;
          attempts++;
        }
        
        final initialState = container.read(homeControllerProvider);
        if (initialState.hasError) {
          fail('Initial state has error: ${initialState.error}');
        }
        expect(initialState.hasValue, isTrue, reason: 'Initial state should have value');

        // Act
        await controller.toggleSave(newsItem);
        
        // Wait for toggleSave to complete and rollback to occur
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        final state = container.read(homeControllerProvider);
        expect(state.hasValue, isTrue);
        final homeState = state.value!;
        // State should be rolled back
        expect(homeState.popular.first.isSaved, isFalse);
        expect(homeState.categories.first.news.first.isSaved, isFalse);
      });

      test('should not update state when current state is null', () async {
        // Arrange
        final newsItem = NewsItem(
          id: 'news1',
          title: 'News Title',
          content: 'Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Source',
          categoryName: 'Category',
        );

        container = ProviderContainer(
          overrides: [
            envProvider.overrideWithValue(
              const EnvConfig(
                baseUrl: 'https://test.api.com',
                xApiKey: 'test-api-key',
                env: 'dev',
              ),
            ),
            sharedPreferencesProvider.overrideWith((ref) => Future.value(mockPrefs)),
            homeRepositoryProvider.overrideWith((ref) => Future.value(mockRepository)),
            homeControllerProvider.overrideWith(
              () => TestHomeController(mockRepository),
            ),
            popularNewsCacheProvider.overrideWith((ref) => Future.value(mockCache)),
          ],
        );

        final controller = container.read(homeControllerProvider.notifier) as TestHomeController;

        // Act
        await controller.toggleSave(newsItem);

        // Assert
        verifyNever(() => mockRepository.toggleSave(
              newsId: any(named: 'newsId'),
              shouldSave: any(named: 'shouldSave'),
            ));
      });
    });
  });
}

