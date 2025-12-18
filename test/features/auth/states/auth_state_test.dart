import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/features/auth/states/auth_state.dart';

void main() {
  group('AuthState', () {
    test('should have default values', () {
      // Act
      const state = AuthState();

      // Assert
      expect(state.email, isEmpty);
      expect(state.password, isEmpty);
      expect(state.confirmPassword, isEmpty);
      expect(state.obscurePassword, isTrue);
      expect(state.obscureConfirmPassword, isTrue);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });

    test('passwordsMatch should return true when passwords match', () {
      // Arrange
      const state = AuthState(
        password: 'password123',
        confirmPassword: 'password123',
      );

      // Act & Assert
      expect(state.passwordsMatch, isTrue);
    });

    test('passwordsMatch should return false when passwords do not match', () {
      // Arrange
      const state = AuthState(
        password: 'password123',
        confirmPassword: 'password456',
      );

      // Act & Assert
      expect(state.passwordsMatch, isFalse);
    });

    test('passwordsMatch should return false when password is empty', () {
      // Arrange
      const state = AuthState(
        password: '',
        confirmPassword: 'password123',
      );

      // Act & Assert
      expect(state.passwordsMatch, isFalse);
    });

    test('passwordsMatch should return false when confirmPassword is empty', () {
      // Arrange
      const state = AuthState(
        password: 'password123',
        confirmPassword: '',
      );

      // Act & Assert
      expect(state.passwordsMatch, isFalse);
    });

    test('copyWith should update email', () {
      // Arrange
      const state = AuthState(email: 'old@test.com');

      // Act
      final newState = state.copyWith(email: 'new@test.com');

      // Assert
      expect(newState.email, equals('new@test.com'));
      expect(newState.password, equals(state.password));
    });

    test('copyWith should update password', () {
      // Arrange
      const state = AuthState(password: 'oldpass');

      // Act
      final newState = state.copyWith(password: 'newpass');

      // Assert
      expect(newState.password, equals('newpass'));
      expect(newState.email, equals(state.email));
    });

    test('copyWith should update error to null when error is null', () {
      // Arrange
      const state = AuthState(error: 'Some error');

      // Act
      final newState = state.copyWith(error: null);

      // Assert
      expect(newState.error, isNull);
    });

    test('copyWith should preserve other values when updating one field', () {
      // Arrange
      const state = AuthState(
        email: 'test@test.com',
        password: 'password123',
        confirmPassword: 'password123',
        obscurePassword: false,
        isSubmitting: true,
      );

      // Act
      final newState = state.copyWith(email: 'new@test.com');

      // Assert
      expect(newState.email, equals('new@test.com'));
      expect(newState.password, equals('password123'));
      expect(newState.confirmPassword, equals('password123'));
      expect(newState.obscurePassword, isFalse);
      expect(newState.isSubmitting, isTrue);
    });
  });
}

