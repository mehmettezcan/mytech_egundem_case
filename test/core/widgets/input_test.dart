import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytech_egundem_case/core/widgets/input.dart';

void main() {
  group('EgundemInput', () {
    testWidgets('should display hint text', (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('should call onChanged when text is entered',
        (WidgetTester tester) async {
      // Arrange
      String? changedValue;
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@test.com');
      await tester.pump();

      // Assert
      expect(changedValue, equals('test@test.com'));
    });

    testWidgets('should obscure text when obscureText is true',
        (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your password';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              obscureText: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final textFieldFinder = find.byType(TextField);
      final TextField textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isTrue);
    });

    testWidgets('should not obscure text when obscureText is false',
        (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              obscureText: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final textFieldFinder = find.byType(TextField);
      final TextField textField = tester.widget(textFieldFinder);
      expect(textField.obscureText, isFalse);
    });

    testWidgets('should display suffix widget when provided',
        (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your password';
      const suffix = Icon(Icons.visibility);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              suffix: suffix,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should have error border when errorBorder is true',
        (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              errorBorder: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final textFieldFinder = find.byType(TextField);
      final TextField textField = tester.widget(textFieldFinder);
      final inputDecoration = textField.decoration as InputDecoration;
      expect(inputDecoration.enabledBorder, isNotNull);
      expect(inputDecoration.focusedBorder, isNotNull);
    });

    testWidgets('should use correct keyboard type when provided',
        (WidgetTester tester) async {
      // Arrange
      const hint = 'Enter your email';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EgundemInput(
              hint: hint,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      final textFieldFinder = find.byType(TextField);
      final TextField textField = tester.widget(textFieldFinder);
      expect(textField.keyboardType, equals(TextInputType.emailAddress));
    });
  });
}

