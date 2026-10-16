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

      expect(find.text('Tubigon Marketplace System'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);

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

      expect(find.text('Welcome to Tubigon!'), findsOneWidget);
      expect(find.text('Maya Santos'), findsOneWidget);
      expect(find.text('Sign up'), findsNothing);
      expect(find.text('Log in'), findsNothing);
    },
  );

  testWidgets(
    'profile offers sign up before registration',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TubigonMarketplaceApp());
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Tubigon!'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    },
  );

  testWidgets(
    'posting a listing shows a profile notification until profile is opened',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TubigonMarketplaceApp());
      await tester.tap(find.text('Post Item'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Local table');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'A sturdy wooden table.',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '1500');
      await tester.tap(find.text('Publish Listing'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('New listing notification'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('New listing notification'), findsNothing);
      expect(find.text('Local table'), findsOneWidget);
    },
  );
}
