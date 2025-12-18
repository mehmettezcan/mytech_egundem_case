import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/features/sources/data/models/follow_source_dto.dart';
import 'package:mytech_egundem_case/features/sources/data/models/news_source.dart';
import 'package:mytech_egundem_case/features/sources/data/source_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('SourceRepository', () {
    late MockApiClient mockApiClient;
    late SourceRepository repository;

    setUp(() {
      mockApiClient = MockApiClient();
      repository = SourceRepository(mockApiClient);
    });

    group('getAllSources', () {
      test('should return list of news sources', () async {
        // Arrange
        final sourceJson = {
          'id': 'src1',
          'name': 'Source 1',
          'description': 'Description',
          'imageUrl': 'https://test.com/image.jpg',
          'sourceCategoryId': 'cat1',
          'sourceCategoryTitle': 'Category',
          'isFollowed': false,
        };

        final responseData = {
          'sources': [sourceJson],
        };

        final response = Response(
          requestOptions: RequestOptions(path: '/sources'),
          data: responseData,
          statusCode: 200,
        );

        when(() => mockApiClient.get(any())).thenAnswer((_) async => response);

        // Act
        final result = await repository.getAllSources();

        // Assert
        expect(result.length, equals(1));
        expect(result.first.id, equals('src1'));
        expect(result.first.name, equals('Source 1'));

        verify(() => mockApiClient.get('/sources')).called(1);
      });

      test('should throw exception when response is invalid', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/sources'),
          data: {'invalid': 'data'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(any())).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getAllSources(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid sources response'),
          )),
        );
      });

      test('should throw exception when sources is not a List', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/sources'),
          data: {'sources': 'not a list'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(any())).thenAnswer((_) async => response);

        // Act & Assert
        expect(
          () => repository.getAllSources(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('syncFollowedSources', () {
      test('should post followed sources', () async {
        // Arrange
        final followDtos = [
          FollowSourceDto(sourceId: 'src1', isFollowed: true),
          FollowSourceDto(sourceId: 'src2', isFollowed: false),
        ];

        final response = Response(
          requestOptions: RequestOptions(path: '/sources/follow/bulk'),
          data: {'success': true},
          statusCode: 200,
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => response);

        // Act
        await repository.syncFollowedSources(followDtos);

        // Assert
        verify(() => mockApiClient.post(
              '/sources/follow/bulk',
              data: any(named: 'data'),
            )).called(1);
      });

      test('should send correct payload format', () async {
        // Arrange
        final followDtos = [
          FollowSourceDto(sourceId: 'src1', isFollowed: true),
          FollowSourceDto(sourceId: 'src2', isFollowed: false),
        ];

        final response = Response(
          requestOptions: RequestOptions(path: '/sources/follow/bulk'),
          data: {'success': true},
          statusCode: 200,
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => response);

        // Act
        await repository.syncFollowedSources(followDtos);

        // Assert
        final captured = verify(() => mockApiClient.post(
              any(),
              data: captureAny(named: 'data'),
            )).captured;

        expect(captured.length, equals(1));
        final payload = captured.first as List;
        expect(payload.length, equals(2));
        expect(payload[0]['sourceId'], equals('src1'));
        expect(payload[0]['isFollowed'], isTrue);
        expect(payload[1]['sourceId'], equals('src2'));
        expect(payload[1]['isFollowed'], isFalse);
      });
    });
  });
}


