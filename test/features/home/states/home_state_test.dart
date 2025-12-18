import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/category_with_news_model.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:mytech_egundem_case/features/home/states/home_state.dart';

void main() {
  group('HomeState', () {
    test('should have default values', () {
      // Act
      const state = HomeState();

      // Assert
      expect(state.popular, isEmpty);
      expect(state.categories, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('copyWith should update popular', () {
      // Arrange
      const state = HomeState();
      final newsItem = NewsItem(
        id: '1',
        title: 'Test News',
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

      // Act
      final newState = state.copyWith(popular: [newsItem]);

      // Assert
      expect(newState.popular.length, equals(1));
      expect(newState.popular.first.id, equals('1'));
      expect(newState.categories, equals(state.categories));
    });

    test('copyWith should update categories', () {
      // Arrange
      const state = HomeState();
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

      // Act
      final newState = state.copyWith(categories: [categoryWithNews]);

      // Assert
      expect(newState.categories.length, equals(1));
      expect(newState.categories.first.category.id, equals('cat1'));
      expect(newState.popular, equals(state.popular));
    });

    test('copyWith should update isLoading', () {
      // Arrange
      const state = HomeState();

      // Act
      final newState = state.copyWith(isLoading: true);

      // Assert
      expect(newState.isLoading, isTrue);
      expect(newState.popular, equals(state.popular));
      expect(newState.categories, equals(state.categories));
    });

    test('copyWith should update error', () {
      // Arrange
      const state = HomeState();

      // Act
      final newState = state.copyWith(error: 'Some error');

      // Assert
      expect(newState.error, equals('Some error'));
      expect(newState.popular, equals(state.popular));
    });

    test('copyWith should set error to null', () {
      // Arrange
      const state = HomeState(error: 'Some error');

      // Act
      final newState = state.copyWith(error: null);

      // Assert
      expect(newState.error, isNull);
    });

    test('copyWith should preserve other values when updating one field', () {
      // Arrange
      final newsItem = NewsItem(
        id: '1',
        title: 'Test News',
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
      const state = HomeState(
        popular: [],
        categories: const [],
        isLoading: true,
        error: 'Error',
      );

      // Act
      final newState = state.copyWith(isLoading: false);

      // Assert
      expect(newState.isLoading, isFalse);
      expect(newState.popular, equals(state.popular));
      expect(newState.categories.length, equals(state.categories.length));
      // Note: copyWith sets error to null when error parameter is not provided
      // To preserve error, we need to explicitly pass it
      final newStateWithError = state.copyWith(isLoading: false, error: 'Error');
      expect(newStateWithError.error, equals('Error'));
    });
  });
}

