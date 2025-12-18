import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/routes.dart';

void main() {
  group('RouteGenerator', () {
    test('should have correct route constants', () {
      // Assert
      expect(RouteGenerator.splashScreen, equals('/'));
      expect(RouteGenerator.loginScreen, equals('/login'));
      expect(RouteGenerator.signUpScreen, equals('/signup'));
      expect(RouteGenerator.selectSourceScreen, equals('/select-source'));
      expect(RouteGenerator.homeScreen, equals('/home'));
    });

    group('generateRoute', () {
      test('should generate MaterialPageRoute for splash screen', () {
        // Arrange
        const settings = RouteSettings(name: RouteGenerator.splashScreen);

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should generate MaterialPageRoute for login screen', () {
        // Arrange
        const settings = RouteSettings(name: RouteGenerator.loginScreen);

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should generate MaterialPageRoute for signup screen', () {
        // Arrange
        const settings = RouteSettings(name: RouteGenerator.signUpScreen);

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should generate MaterialPageRoute for select source screen', () {
        // Arrange
        const settings = RouteSettings(name: RouteGenerator.selectSourceScreen);

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should generate MaterialPageRoute for home screen', () {
        // Arrange
        const settings = RouteSettings(name: RouteGenerator.homeScreen);

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should generate MaterialPageRoute for unknown routes', () {
        // Arrange
        const settings = RouteSettings(name: '/unknown');

        // Act
        final route = RouteGenerator.generateRoute(settings);

        // Assert
        expect(route, isA<MaterialPageRoute>());
      });

      test('should return MaterialPageRoute for all known routes', () {
        // Test that all known routes return MaterialPageRoute
        final routes = [
          RouteGenerator.splashScreen,
          RouteGenerator.loginScreen,
          RouteGenerator.signUpScreen,
          RouteGenerator.selectSourceScreen,
          RouteGenerator.homeScreen,
        ];

        for (final routeName in routes) {
          final route = RouteGenerator.generateRoute(
            RouteSettings(name: routeName),
          );
          expect(route, isA<MaterialPageRoute>());
        }
      });
    });
  });
}
