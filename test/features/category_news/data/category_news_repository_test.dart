import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/features/category_news/data/category_news_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('CategoryNewsRepository', () {
    late MockApiClient mockApiClient;
    late CategoryNewsRepository repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = CategoryNewsRepository(mockApiClient);
    });

    group('getCategoryNews', () {
      test('should return category news items with pagination info', () async {
        // Arrange
        const categoryId = 'cat1';
        const page = 1;
        const pageSize = 10;

        final newsItemJson = {
          '_id': 'news1',
          '_title': 'News Title',
          '_content': 'Content',
          '_imageUrl': 'https://test.com/image.jpg',
          '_categoryId': 'cat1',
          '_sourceId': 'src1',
          '_sourceProfilePictureUrl': 'https://test.com/profile.jpg',
          '_sourceTitle': 'Source',
          '_sourceName': 'Source Name',
          '_publishedAt': DateTime.now().toIso8601String(),
          '_isSaved': false,
          '_isLatest': true,
          '_isPopular': true,
        };

        final responseData = {
          'result': {
            'items': [newsItemJson],
            'total': 50,
            'page': page,
            'pageSize': pageSize,
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/news/category/$categoryId'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await repository.getCategoryNews(
          categoryId: categoryId,
          page: page,
          pageSize: pageSize,
        );

        // Assert
        expect(result.items.length, equals(1));
        expect(result.items.first.id, equals('news1'));
        expect(result.total, equals(50));
        expect(result.page, equals(page));
        expect(result.pageSize, equals(pageSize));

        verify(() => mockApiClient.get(
              '/news/category/$categoryId',
              queryParameters: {'page': page, 'pageSize': pageSize},
            )).called(1);
      });

      test('should throw exception when response is invalid', () async {
        // Arrange
        const categoryId = 'cat1';
        final response = Response(
          requestOptions: RequestOptions(path: '/news/category/$categoryId'),
          data: {'invalid': 'data'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getCategoryNews(
            categoryId: categoryId,
            page: 1,
            pageSize: 10,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid category news response'),
          )),
        );
      });

      test('should throw exception when result is not a Map', () async {
        // Arrange
        const categoryId = 'cat1';
        final response = Response(
          requestOptions: RequestOptions(path: '/news/category/$categoryId'),
          data: {'result': 'not a map'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getCategoryNews(
            categoryId: categoryId,
            page: 1,
            pageSize: 10,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when items is not a List', () async {
        // Arrange
        const categoryId = 'cat1';
        final response = Response(
          requestOptions: RequestOptions(path: '/news/category/$categoryId'),
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
          () => repository.getCategoryNews(
            categoryId: categoryId,
            page: 1,
            pageSize: 10,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid items'),
          )),
        );
      });

      test('should use default values when total, page, pageSize are missing', () async {
        // Arrange
        const categoryId = 'cat1';
        const page = 1;
        const pageSize = 10;

        final newsItemJson = {
          '_id': 'news1',
          '_title': 'News Title',
          '_content': 'Content',
          '_imageUrl': 'https://test.com/image.jpg',
          '_categoryId': 'cat1',
          '_sourceId': 'src1',
          '_sourceProfilePictureUrl': 'https://test.com/profile.jpg',
          '_sourceTitle': 'Source',
          '_sourceName': 'Source Name',
          '_publishedAt': DateTime.now().toIso8601String(),
          '_isSaved': false,
          '_isLatest': true,
          '_isPopular': true,
        };

        final responseData = {
          'result': {
            'items': [newsItemJson],
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/news/category/$categoryId'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await repository.getCategoryNews(
          categoryId: categoryId,
          page: page,
          pageSize: pageSize,
        );

        // Assert
        expect(result.total, equals(0));
        expect(result.page, equals(page));
        expect(result.pageSize, equals(pageSize));
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
        await repository.toggleSave(newsId: newsId, shouldSave: true);

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
        await repository.toggleSave(newsId: newsId, shouldSave: false);

        // Assert
        verify(() => mockApiClient.delete('/saved-news/$newsId')).called(1);
        verifyNever(() => mockApiClient.post(any(), data: any(named: 'data')));
      });
    });
  });
}

