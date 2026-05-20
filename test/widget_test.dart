// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_ci_setup/main.dart';
import 'package:flutter_ci_setup/presentation/home/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('MyApp renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MyApp), findsOneWidget);
    });

    testWidgets('MyHomePage renders with title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Flutter Demo Home Page'), findsOneWidget);
    });

    testWidgets('Counter starts at 0', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verify that counter displays 0
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('Counter increments on button tap', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Verify initial state
      expect(find.text('0'), findsOneWidget);

      // Tap the '+' button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify counter incremented to 1
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Counter increments multiple times', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Tap button 5 times
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }

      // Verify counter is at 5
      expect(find.text('5'), findsOneWidget);
      expect(find.text('4'), findsNothing);
    });

    testWidgets('FloatingActionButton is present', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Center widget and text widgets are rendered', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // Multiple Center widgets may exist in the tree (Flutter's auto-layout)
      // Just verify we have at least one Center widget
      expect(find.byType(Center), findsWidgets);
      expect(
        find.text('You have pushed the button this many times:'),
        findsOneWidget,
      );
    });

    testWidgets('Scaffold contains all necessary widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
