import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/routes.dart';

void main() {
  group('MyApp Configuration', () {
    test('should have correct route constants', () {
      // Test route constants
      expect(RouteGenerator.splashScreen, equals('/'));
      expect(RouteGenerator.loginScreen, equals('/login'));
      expect(RouteGenerator.signUpScreen, equals('/signup'));
      expect(RouteGenerator.selectSourceScreen, equals('/select-source'));
      expect(RouteGenerator.homeScreen, equals('/home'));
    });

    test('should use RouteGenerator for route generation', () {
      // Test that RouteGenerator.generateRoute exists and works
      final route = RouteGenerator.generateRoute(
        const RouteSettings(name: '/test'),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate all known routes', () {
      // Test all known routes
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
}

