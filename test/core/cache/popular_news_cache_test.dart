import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/cache/popular_news_cache.dart';
import 'package:mytech_egundem_case/features/home/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('PopularNewsCache', () {
    late MockSharedPreferences mockPrefs;
    late PopularNewsCache cache;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      cache = PopularNewsCache(mockPrefs);
    });

    group('getIfValid', () {
      test('should return null when timestamp is null', () {
        // Arrange
        when(() => mockPrefs.getInt('popular_news_ts')).thenReturn(null);

        // Act
        final result = cache.getIfValid();

        // Assert
        expect(result, isNull);
      });

      test('should return null when data is null', () {
        // Arrange
        when(() => mockPrefs.getInt('popular_news_ts')).thenReturn(1234567890);
        when(() => mockPrefs.getString('popular_news_data')).thenReturn(null);

        // Act
        final result = cache.getIfValid();

        // Assert
        expect(result, isNull);
      });

      test('should return null when cache is expired', () {
        // Arrange
        final expiredTimestamp = DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch;
        when(() => mockPrefs.getInt('popular_news_ts'))
            .thenReturn(expiredTimestamp);
        when(() => mockPrefs.getString('popular_news_data'))
            .thenReturn('[]');

        // Act
        final result = cache.getIfValid();

        // Assert
        expect(result, isNull);
      });

      test('should return cached data when valid', () {
        // Arrange
        final validTimestamp = DateTime.now()
            .subtract(const Duration(minutes: 30))
            .millisecondsSinceEpoch;
        final newsItem = NewsItem(
          id: '1',
          title: 'Test News',
          content: 'Test Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Test Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Test Source',
          categoryName: 'Test Category',
        );
        final jsonData = jsonEncode([newsItem.toJson()]);

        when(() => mockPrefs.getInt('popular_news_ts'))
            .thenReturn(validTimestamp);
        when(() => mockPrefs.getString('popular_news_data'))
            .thenReturn(jsonData);

        // Act
        final result = cache.getIfValid();

        // Assert
        expect(result, isNotNull);
        expect(result!.length, equals(1));
        expect(result.first.id, equals('1'));
        expect(result.first.title, equals('Test News'));
      });

      test('should throw FormatException when data is not valid JSON', () {
        // Arrange
        final validTimestamp = DateTime.now()
            .subtract(const Duration(minutes: 30))
            .millisecondsSinceEpoch;
        when(() => mockPrefs.getInt('popular_news_ts'))
            .thenReturn(validTimestamp);
        when(() => mockPrefs.getString('popular_news_data'))
            .thenReturn('invalid json');

        // Act & Assert
        expect(() => cache.getIfValid(), throwsA(isA<FormatException>()));
      });
    });

    group('save', () {
      test('should save news items with current timestamp', () async {
        // Arrange
        final newsItem = NewsItem(
          id: '1',
          title: 'Test News',
          content: 'Test Content',
          imageUrl: 'https://test.com/image.jpg',
          categoryId: 'cat1',
          sourceId: 'src1',
          sourceTitle: 'Test Source',
          sourceProfilePictureUrl: 'https://test.com/profile.jpg',
          publishedAt: DateTime.now(),
          isSaved: false,
          isLatest: true,
          isPopular: true,
          sourceName: 'Test Source',
          categoryName: 'Test Category',
        );
        final items = [newsItem];

        when(() => mockPrefs.setInt(any(), any()))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(any(), any()))
            .thenAnswer((_) async => true);

        // Act
        await cache.save(items);

        // Assert
        verify(() => mockPrefs.setInt('popular_news_ts', any())).called(1);
        verify(() => mockPrefs.setString('popular_news_data', any()))
            .called(1);
      });
    });

    group('clear', () {
      test('should remove timestamp and data from SharedPreferences', () async {
        // Arrange
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        // Act
        await cache.clear();

        // Assert
        verify(() => mockPrefs.remove('popular_news_ts')).called(1);
        verify(() => mockPrefs.remove('popular_news_data')).called(1);
      });
    });
  });
}

