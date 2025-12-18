import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('AuthController', () {
    late ProviderContainer container;
    late AuthController controller;

    setUp(() {
      container = ProviderContainer();
      controller = container.read(authControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default state', () {
      // Act
      final state = container.read(authControllerProvider);

      // Assert
      expect(state.email, isEmpty);
      expect(state.password, isEmpty);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });

    group('setEmail', () {
      test('should update email and clear error', () {
        // Arrange
        controller.state = controller.state.copyWith(error: 'Some error');

        // Act
        controller.setEmail('test@test.com');

        // Assert
        expect(controller.state.email, equals('test@test.com'));
        expect(controller.state.error, isNull);
      });
    });

    group('setPassword', () {
      test('should update password and clear error', () {
        // Arrange
        controller.state = controller.state.copyWith(error: 'Some error');

        // Act
        controller.setPassword('password123');

        // Assert
        expect(controller.state.password, equals('password123'));
        expect(controller.state.error, isNull);
      });
    });

    group('setConfirmPassword', () {
      test('should update confirmPassword and clear error', () {
        // Arrange
        controller.state = controller.state.copyWith(error: 'Some error');

        // Act
        controller.setConfirmPassword('password123');

        // Assert
        expect(controller.state.confirmPassword, equals('password123'));
        expect(controller.state.error, isNull);
      });
    });

    group('togglePassword', () {
      test('should toggle obscurePassword from true to false', () {
        // Arrange
        expect(controller.state.obscurePassword, isTrue);

        // Act
        controller.togglePassword();

        // Assert
        expect(controller.state.obscurePassword, isFalse);
      });

      test('should toggle obscurePassword from false to true', () {
        // Arrange
        controller.state = controller.state.copyWith(obscurePassword: false);

        // Act
        controller.togglePassword();

        // Assert
        expect(controller.state.obscurePassword, isTrue);
      });
    });

    group('toggleConfirmPassword', () {
      test('should toggle obscureConfirmPassword from true to false', () {
        // Arrange
        expect(controller.state.obscureConfirmPassword, isTrue);

        // Act
        controller.toggleConfirmPassword();

        // Assert
        expect(controller.state.obscureConfirmPassword, isFalse);
      });
    });

    group('clearError', () {
      test('should clear error', () {
        // Arrange
        controller.state = controller.state.copyWith(error: 'Some error');

        // Act
        controller.clearError();

        // Assert
        expect(controller.state.error, isNull);
      });
    });

    group('submitSignup', () {
      test('should set error when email is invalid', () async {
        // Arrange
        controller.setEmail('invalid-email');
        controller.setPassword('password123');
        controller.setConfirmPassword('password123');

        // Act
        await controller.submitSignup(
          onSignup: ({required email, required password}) async {},
        );

        // Assert
        expect(controller.state.error, contains('valid email'));
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should set error when password is too short', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('12345');
        controller.setConfirmPassword('12345');

        // Act
        await controller.submitSignup(
          onSignup: ({required email, required password}) async {},
        );

        // Assert
        expect(controller.state.error, contains('at least 6 characters'));
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should set error when passwords do not match', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('password123');
        controller.setConfirmPassword('password456');

        // Act
        await controller.submitSignup(
          onSignup: ({required email, required password}) async {},
        );

        // Assert
        expect(controller.state.error, contains('do not match'));
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should call onSignup when validation passes', () async {
        // Arrange
        var signupCalled = false;
        controller.setEmail('test@test.com');
        controller.setPassword('password123');
        controller.setConfirmPassword('password123');

        // Act
        await controller.submitSignup(
          onSignup: ({required email, required password}) async {
            signupCalled = true;
            expect(email, equals('test@test.com'));
            expect(password, equals('password123'));
          },
        );

        // Assert
        expect(signupCalled, isTrue);
        expect(controller.state.isSubmitting, isFalse);
        expect(controller.state.error, isNull);
      });

      test('should set isSubmitting to true during signup', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('password123');
        controller.setConfirmPassword('password123');

        // Act
        final future = controller.submitSignup(
          onSignup: ({required email, required password}) async {
            // Check state during async operation
            expect(controller.state.isSubmitting, isTrue);
            await Future.delayed(const Duration(milliseconds: 10));
          },
        );

        // Wait for completion
        await future;

        // Assert
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should set error when onSignup throws exception', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('password123');
        controller.setConfirmPassword('password123');

        // Act
        await controller.submitSignup(
          onSignup: ({required email, required password}) async {
            throw Exception('Signup failed');
          },
        );

        // Assert
        expect(controller.state.error, contains('Signup failed'));
        expect(controller.state.isSubmitting, isFalse);
      });

    });

    group('submitLogin', () {
      test('should set error when email is invalid', () async {
        // Arrange
        controller.setEmail('invalid-email');
        controller.setPassword('password123');

        // Act
        await controller.submitLogin(
          onLogin: ({required email, required password}) async {},
        );

        // Assert
        expect(controller.state.error, contains('valid email'));
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should set error when password is empty', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('');

        // Act
        await controller.submitLogin(
          onLogin: ({required email, required password}) async {},
        );

        // Assert
        expect(controller.state.error, contains('Password is required'));
        expect(controller.state.isSubmitting, isFalse);
      });

      test('should call onLogin when validation passes', () async {
        // Arrange
        var loginCalled = false;
        controller.setEmail('test@test.com');
        controller.setPassword('password123');

        // Act
        await controller.submitLogin(
          onLogin: ({required email, required password}) async {
            loginCalled = true;
            expect(email, equals('test@test.com'));
            expect(password, equals('password123'));
          },
        );

        // Assert
        expect(loginCalled, isTrue);
        expect(controller.state.isSubmitting, isFalse);
        expect(controller.state.error, isNull);
      });

      test('should set error when onLogin throws exception', () async {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('password123');

        // Act
        await controller.submitLogin(
          onLogin: ({required email, required password}) async {
            throw Exception('Login failed');
          },
        );

        // Assert
        expect(controller.state.error, contains('Login failed'));
        expect(controller.state.isSubmitting, isFalse);
      });

    });

    group('reset', () {
      test('should reset state to initial values', () {
        // Arrange
        controller.setEmail('test@test.com');
        controller.setPassword('password123');
        controller.state = controller.state.copyWith(
          isSubmitting: true,
          error: 'Some error',
        );

        // Act
        controller.reset();

        // Assert
        expect(controller.state.email, isEmpty);
        expect(controller.state.password, isEmpty);
        expect(controller.state.isSubmitting, isFalse);
        expect(controller.state.error, isNull);
      });
    });
  });
}

