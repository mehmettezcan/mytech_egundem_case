import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loggy/loggy.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('ApiClient', () {
    late MockDio mockDio;
    late Loggy loggy;
    late ApiClient apiClient;

    setUp(() {
      mockDio = MockDio();
      loggy = Loggy('ApiClientTest');
      apiClient = ApiClient(dio: mockDio, loggy: loggy);
    });

    group('get', () {
      test('should call dio.get with correct parameters', () async {
        // Arrange
        const path = '/test';
        final queryParams = {'page': 1};
        final response = Response(
          requestOptions: RequestOptions(path: path),
          data: {'result': 'success'},
          statusCode: 200,
        );

        when(() => mockDio.get<dynamic>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.get(path, queryParameters: queryParams);

        // Assert
        expect(result, equals(response));
        verify(() => mockDio.get<dynamic>(
              path,
              queryParameters: queryParams,
              options: any(named: 'options'),
            )).called(1);
      });

      test('should call dio.get without query parameters', () async {
        // Arrange
        const path = '/test';
        final response = Response(
          requestOptions: RequestOptions(path: path),
          data: {'result': 'success'},
          statusCode: 200,
        );

        when(() => mockDio.get<dynamic>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.get(path);

        // Assert
        expect(result, equals(response));
        verify(() => mockDio.get<dynamic>(
              path,
              queryParameters: null,
              options: any(named: 'options'),
            )).called(1);
      });
    });

    group('post', () {
      test('should call dio.post with correct parameters', () async {
        // Arrange
        const path = '/test';
        final data = {'email': 'test@test.com'};
        final response = Response(
          requestOptions: RequestOptions(path: path),
          data: {'result': 'success'},
          statusCode: 201,
        );

        when(() => mockDio.post<dynamic>(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.post(path, data: data);

        // Assert
        expect(result, equals(response));
        verify(() => mockDio.post<dynamic>(
              path,
              data: data,
              queryParameters: null,
              options: any(named: 'options'),
            )).called(1);
      });
    });

    group('put', () {
      test('should call dio.put with correct parameters', () async {
        // Arrange
        const path = '/test';
        final data = {'name': 'updated'};
        final response = Response(
          requestOptions: RequestOptions(path: path),
          data: {'result': 'success'},
          statusCode: 200,
        );

        when(() => mockDio.put<dynamic>(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.put(path, data: data);

        // Assert
        expect(result, equals(response));
        verify(() => mockDio.put<dynamic>(
              path,
              data: data,
              queryParameters: null,
              options: any(named: 'options'),
            )).called(1);
      });
    });

    group('delete', () {
      test('should call dio.delete with correct parameters', () async {
        // Arrange
        const path = '/test/123';
        final response = Response(
          requestOptions: RequestOptions(path: path),
          data: null,
          statusCode: 204,
        );

        when(() => mockDio.delete<dynamic>(
              any(),
              data: any(named: 'data'),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => response);

        // Act
        final result = await apiClient.delete(path);

        // Assert
        expect(result, equals(response));
        verify(() => mockDio.delete<dynamic>(
              path,
              data: null,
              queryParameters: null,
              options: any(named: 'options'),
            )).called(1);
      });
    });
  });
}

