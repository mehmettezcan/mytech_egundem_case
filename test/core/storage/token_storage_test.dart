import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mytech_egundem_case/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('TokenStorage', () {
    late MockSharedPreferences mockPrefs;
    late TokenStorage tokenStorage;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      tokenStorage = TokenStorage(mockPrefs);
    });

    test('saveAccessToken should save token to SharedPreferences', () async {
      // Arrange
      const token = 'test_access_token';
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);

      // Act
      await tokenStorage.saveAccessToken(token);

      // Assert
      verify(() => mockPrefs.setString('auth_token_egundem', token)).called(1);
    });

    test('accessToken should return token from SharedPreferences', () {
      // Arrange
      const token = 'test_access_token';
      when(() => mockPrefs.getString('auth_token_egundem')).thenReturn(token);

      // Act
      final result = tokenStorage.accessToken;

      // Assert
      expect(result, equals(token));
      verify(() => mockPrefs.getString('auth_token_egundem')).called(1);
    });

    test('accessToken should return null when token does not exist', () {
      // Arrange
      when(() => mockPrefs.getString('auth_token_egundem')).thenReturn(null);

      // Act
      final result = tokenStorage.accessToken;

      // Assert
      expect(result, isNull);
      verify(() => mockPrefs.getString('auth_token_egundem')).called(1);
    });

    test('clear should remove token from SharedPreferences', () async {
      // Arrange
      when(() => mockPrefs.remove('auth_token_egundem')).thenAnswer((_) async => true);

      // Act
      await tokenStorage.clear();

      // Assert
      verify(() => mockPrefs.remove('auth_token_egundem')).called(1);
    });
  });
}

