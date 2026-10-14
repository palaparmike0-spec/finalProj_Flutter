import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubigonsmarketplace/main.dart';

void main() {
  testWidgets(
    'Marketplace app launches',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const TubigonMarketplaceApp(),
      );

      expect(find.text('Find it in Tubigon'), findsOneWidget);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Post Item'), findsOneWidget);
      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets(
    'sign up updates the profile greeting',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TubigonMarketplaceApp());

      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Maya Santos');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'maya@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.tap(find.widgetWithText(FilledButton, 'Sign up'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Tubigon (Maya Santos)'), findsOneWidget);
      expect(find.text('Log in'), findsNothing);
    },
  );
}
