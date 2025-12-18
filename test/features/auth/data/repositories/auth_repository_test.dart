import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/storage/token_storage.dart';
import 'package:mytech_egundem_case/features/auth/data/repositories/auth_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  group('AuthRepository', () {
    late MockApiClient mockApiClient;
    late MockTokenStorage mockTokenStorage;
    late AuthRepository authRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      mockTokenStorage = MockTokenStorage();
      authRepository = AuthRepository(mockApiClient, mockTokenStorage);
    });

    group('signup', () {
      test('should save access token on successful signup', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';
        const accessToken = 'test_access_token';

        final response = Response(
          requestOptions: RequestOptions(path: '/users'),
          data: {'accessToken': accessToken},
          statusCode: 201,
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => response);
        when(() => mockTokenStorage.saveAccessToken(any()))
            .thenAnswer((_) async => {});

        // Act
        await authRepository.signup(email: email, password: password);

        // Assert
        verify(() => mockApiClient.post(
              '/users',
              data: any(named: 'data'),
            )).called(1);
        verify(() => mockTokenStorage.saveAccessToken(accessToken)).called(1);
      });

      test('should throw exception when email already exists (409)', () async {
        // Arrange
        const email = 'existing@test.com';
        const password = 'password123';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users'),
          response: Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 409,
          ),
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.signup(email: email, password: password),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('already in use'),
          )),
        );
      });

      test('should throw exception when validation fails (422)', () async {
        // Arrange
        const email = 'invalid';
        const password = '123';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users'),
          response: Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 422,
          ),
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.signup(email: email, password: password),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid email or password'),
          )),
        );
      });

      test('should throw exception on server error (500)', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users'),
          response: Response(
            requestOptions: RequestOptions(path: '/users'),
            statusCode: 500,
          ),
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.signup(email: email, password: password),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Server error'),
          )),
        );
      });
    });

    group('login', () {
      test('should save access token on successful login', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';
        const accessToken = 'test_access_token';

        final response = Response(
          requestOptions: RequestOptions(path: '/users/login/'),
          data: {'accessToken': accessToken},
          statusCode: 200,
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenAnswer((_) async => response);
        when(() => mockTokenStorage.saveAccessToken(any()))
            .thenAnswer((_) async => {});

        // Act
        await authRepository.login(email: email, password: password);

        // Assert
        verify(() => mockApiClient.post(
              '/users/login/',
              data: any(named: 'data'),
            )).called(1);
        verify(() => mockTokenStorage.saveAccessToken(accessToken)).called(1);
      });

      test('should throw exception on invalid credentials (401)', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'wrongpassword';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users/login/'),
          response: Response(
            requestOptions: RequestOptions(path: '/users/login/'),
            statusCode: 401,
          ),
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.login(email: email, password: password),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid email or password'),
          )),
        );
      });

      test('should throw exception on server error (500)', () async {
        // Arrange
        const email = 'test@test.com';
        const password = 'password123';

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users/login/'),
          response: Response(
            requestOptions: RequestOptions(path: '/users/login/'),
            statusCode: 500,
          ),
        );

        when(() => mockApiClient.post(
              any(),
              data: any(named: 'data'),
            )).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.login(email: email, password: password),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Server error'),
          )),
        );
      });
    });

    group('getUserProfile', () {
      test('should successfully get user profile', () async {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/users/profile/'),
          data: {'id': '123', 'email': 'test@test.com'},
          statusCode: 200,
        );

        when(() => mockApiClient.get(any())).thenAnswer((_) async => response);

        // Act
        await authRepository.getUserProfile();

        // Assert
        verify(() => mockApiClient.get('/users/profile/')).called(1);
      });

      test('should throw exception when unauthorized (401)', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users/profile/'),
          response: Response(
            requestOptions: RequestOptions(path: '/users/profile/'),
            statusCode: 401,
          ),
        );

        when(() => mockApiClient.get(any())).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.getUserProfile(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Unauthorized'),
          )),
        );
      });

      test('should throw exception on server error (500)', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/users/profile/'),
          response: Response(
            requestOptions: RequestOptions(path: '/users/profile/'),
            statusCode: 500,
          ),
        );

        when(() => mockApiClient.get(any())).thenThrow(dioException);

        // Act & Assert
        expect(
          () => authRepository.getUserProfile(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Server error'),
          )),
        );
      });
    });
  });
}

