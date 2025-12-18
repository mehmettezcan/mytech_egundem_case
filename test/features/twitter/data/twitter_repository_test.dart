import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/features/twitter/data/models/tweet_item.dart';
import 'package:mytech_egundem_case/features/twitter/data/twitter_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('TwitterRepository', () {
    late MockApiClient mockApiClient;
    late TwitterRepository repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = TwitterRepository(mockApiClient);
    });

    group('getTweets', () {
      test('should return list of tweets', () async {
        // Arrange
        const page = 1;
        const pageSize = 10;
        const isPopular = true;

        final tweetJson = {
          'id': 'tweet1',
          'accountId': 'acc1',
          'accountName': 'Account Name',
          'accountImageUrl': 'https://test.com/image.jpg',
          'content': 'Tweet content',
          'createdAt': DateTime.now().toIso8601String(),
          'isPopular': true,
        };

        final responseData = {
          'result': {
            'items': [tweetJson],
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await repository.getTweets(
          page: page,
          pageSize: pageSize,
          isPopular: isPopular,
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.id, equals('tweet1'));
        expect(result.first.accountName, equals('Account Name'));

        verify(() => mockApiClient.get(
              any(),
              queryParameters: {
                'page': page,
                'pageSize': pageSize,
                'isPopular': isPopular,
              },
            )).called(1);
      });

      test('should throw exception when response is invalid', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
          data: {'invalid': 'data'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getTweets(
            page: 1,
            pageSize: 10,
            isPopular: true,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid tweets response'),
          )),
        );
      });

      test('should throw exception when result is not a Map', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
          data: {'result': 'not a map'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getTweets(
            page: 1,
            pageSize: 10,
            isPopular: true,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when items is not a List', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
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
          () => repository.getTweets(
            page: 1,
            pageSize: 10,
            isPopular: true,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid tweet items'),
          )),
        );
      });

      test('should use correct query parameters for popular tweets', () async {
        // Arrange
        final responseData = {
          'result': {
            'items': [],
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        await repository.getTweets(
          page: 1,
          pageSize: 10,
          isPopular: true,
        );

        // Assert
        verify(() => mockApiClient.get(
              any(),
              queryParameters: {
                'page': 1,
                'pageSize': 10,
                'isPopular': true,
              },
            )).called(1);
      });

      test('should use correct query parameters for forYou tweets', () async {
        // Arrange
        final responseData = {
          'result': {
            'items': [],
          }
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/twitter/tweetsæ'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(
              any(),
              queryParameters: any(named: 'queryParameters'),
            )).thenAnswer((_) async => response);

        // Act
        await repository.getTweets(
          page: 2,
          pageSize: 20,
          isPopular: false,
        );

        // Assert
        verify(() => mockApiClient.get(
              any(),
              queryParameters: {
                'page': 2,
                'pageSize': 20,
                'isPopular': false,
              },
            )).called(1);
      });
    });
  });
}

