// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eduethiopia/app.dart';
import 'package:eduethiopia/core/theme/app_theme.dart';
import 'package:eduethiopia/features/auth/auth_screen.dart';
import 'package:eduethiopia/features/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('welcome screen displays the Edu Ethiopia entry point', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EduEthiopiaApp());

    expect(find.text('Prepare for the department you want.'), findsOneWidget);
    expect(find.text('Start learning'), findsOneWidget);
    expect(find.text('Freshman + Pre-Eng.'), findsOneWidget);
    expect(find.text('COC exams'), findsOneWidget);
    expect(find.text('Real materials'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Mid Exams'), findsOneWidget);
    expect(find.text('Finals'), findsOneWidget);

    await tester.tap(find.text('አማርኛ'));
    await tester.pump();

    expect(find.text('የሚፈልጉትን ዲፓርትመንት ለማግኘት ይዘጋጁ።'), findsOneWidget);
  });

  testWidgets('authentication form validates required signup fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));

    await tester.tap(find.text('Sign up'));
    await tester.pump();
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Choose your university'), findsWidgets);
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
  });

  testWidgets('authentication header controls receive taps', (
    WidgetTester tester,
  ) async {
    AppThemeController.isDark.value = false;
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/auth',
        routes: {
          '/': (_) => const SizedBox(),
          '/auth': (_) => const AuthScreen(),
        },
      ),
    );

    await tester.tap(find.text('አማርኛ'));
    await tester.pump();
    expect(find.text('ግባ'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to dark theme'));
    await tester.pump();
    expect(find.byTooltip('Switch to light theme'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsNothing);

    AppThemeController.isDark.value = false;
  });

  testWidgets('dashboard preview shows the core study areas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

    expect(find.text('Study hub'), findsOneWidget);
    expect(find.text('Modules'), findsWidgets);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Exams'), findsOneWidget);
    expect(find.text('Videos'), findsOneWidget);
    expect(find.byTooltip('AI Help'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);
    expect(find.text('Mid, Final, and COC'), findsOneWidget);
    expect(find.text('Course notes and chapters'), findsOneWidget);
    expect(find.text('Courses and subjects'), findsOneWidget);
  });

  testWidgets('theme icon switches between dark and light actions', (
    WidgetTester tester,
  ) async {
    AppThemeController.isDark.value = false;
    await tester.pumpWidget(const EduEthiopiaApp());

    expect(find.byTooltip('Switch to dark theme'), findsOneWidget);
    await tester.tap(find.byTooltip('Switch to dark theme'));
    await tester.pump();
    expect(find.byTooltip('Switch to light theme'), findsOneWidget);

    AppThemeController.isDark.value = false;
  });
}
