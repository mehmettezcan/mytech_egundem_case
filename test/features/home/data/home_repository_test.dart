import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/features/home/data/home_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('HomeRepository', () {
    late MockApiClient mockApiClient;
    late HomeRepository homeRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      homeRepository = HomeRepository(mockApiClient);
    });

    group('getCategoriesWithNews', () {
      test('should return categories with news on success', () async {
        // Arrange
        final categoryJson = {
          'id': 'cat1',
          'name': 'Category 1',
        };
        final newsJson = {
          'id': 'news1',
          'title': 'News Title',
          'content': 'Content',
          'imageUrl': 'https://test.com/image.jpg',
          'categoryId': 'cat1',
          'sourceId': 'src1',
          'sourceTitle': 'Source',
          'sourceProfilePictureUrl': 'https://test.com/profile.jpg',
          'publishedAt': DateTime.now().toIso8601String(),
          'isSaved': false,
          'isLatest': true,
          'isPopular': true,
          'sourceName': 'Source',
          'categoryName': 'Category',
        };
        final responseData = {
          'result': {
            'items': [
              {
                'category': categoryJson,
                'news': [newsJson],
              }
            ]
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/categories/with-news'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await homeRepository.getCategoriesWithNews(
          page: 1,
          pageSize: 10,
          isLatest: true,
          forYou: false,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.category.id, equals('cat1'));
        expect(result.first.news.length, equals(1));
        expect(result.first.news.first.id, equals('news1'));

        verify(() => mockApiClient.get(
              '/categories/with-news',
              queryParameters: {
                'page': 1,
                'pageSize': 10,
                'isLatest': true,
                'forYou': false,
              },
            )).called(1);
      });

      test('should throw exception when response is invalid', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/categories/with-news'),
          data: {'invalid': 'data'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => homeRepository.getCategoriesWithNews(
            page: 1,
            pageSize: 10,
            isLatest: true,
            forYou: false,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid categories-with-news response'),
          )),
        );
      });

      test('should throw exception when result is not a Map', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/categories/with-news'),
          data: {'result': 'not a map'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => homeRepository.getCategoriesWithNews(
            page: 1,
            pageSize: 10,
            isLatest: true,
            forYou: false,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when items is not a List', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/categories/with-news'),
          data: {
            'result': {
              'items': 'not a list',
            }
          },
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => homeRepository.getCategoriesWithNews(
            page: 1,
            pageSize: 10,
            isLatest: true,
            forYou: false,
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('toggleSave', () {
      test('should call post when shouldSave is true', () async {
        // Arrange
        const newsId = 'news1';
        final response = Response(
          requestOptions: RequestOptions(path: '/saved-news'),
          data: {'success': true},
          statusCode: 201,
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => response);

        // Act
        await homeRepository.toggleSave(newsId: newsId, shouldSave: true);

        // Assert
        verify(() => mockApiClient.post(
              '/saved-news',
              data: {'newsId': newsId},
            )).called(1);
        verifyNever(() => mockApiClient.delete(any()));
      });

      test('should call delete when shouldSave is false', () async {
        // Arrange
        const newsId = 'news1';
        final response = Response(
          requestOptions: RequestOptions(path: '/saved-news/news1'),
          data: null,
          statusCode: 204,
        );

        when(() => mockApiClient.delete(any())).thenAnswer((_) async => response);

        // Act
        await homeRepository.toggleSave(newsId: newsId, shouldSave: false);

        // Assert
        verify(() => mockApiClient.delete('/saved-news/$newsId')).called(1);
        verifyNever(() => mockApiClient.post(any(), data: any(named: 'data')));
      });
    });
  });
}

