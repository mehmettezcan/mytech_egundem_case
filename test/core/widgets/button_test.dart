import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/core/widgets/button.dart';

void main() {
  group('EgundemButton', () {
    testWidgets('should display child widget', (WidgetTester tester) async {
      // Arrange
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EgundemButton(child: child),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      // ignore: unused_local_variable
      var tapped = false;
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemButton(
              child: child,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(ElevatedButton);
      final ElevatedButton button = tester.widget(buttonFinder);
      
      // Assert
      expect(button.onPressed, isNotNull);
    });

    testWidgets('should not call onPressed when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      var tapped = false;
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemButton(
              child: child,
              isLoading: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EgundemButton));
      await tester.pump();

      // Assert
      expect(tapped, isFalse);
    });

    testWidgets('should show CircularProgressIndicator when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EgundemButton(
              child: child,
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('should have correct button dimensions',
        (WidgetTester tester) async {
      // Arrange
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EgundemButton(child: child),
          ),
        ),
      );

      // Assert
      final buttonFinder = find.byType(EgundemButton);
      final RenderBox box = tester.renderObject(buttonFinder) as RenderBox;
      expect(box.size.height, equals(48));
      final sizedBoxFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(SizedBox),
      );
      final SizedBox sizedBox = tester.widget(sizedBoxFinder);
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets('should have disabled state when isLoading is true',
        (WidgetTester tester) async {
      // Arrange
      const child = Text('Test Button');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EgundemButton(
              child: child,
              isLoading: true,
            ),
          ),
        ),
      );

      // Assert
      final buttonFinder = find.byType(ElevatedButton);
      final ElevatedButton button = tester.widget(buttonFinder);
      expect(button.onPressed, isNull);
    });
  });
}

