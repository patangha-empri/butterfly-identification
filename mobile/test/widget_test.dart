import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';

/// Top-level smoke test — verifies the app theme builds and renders.
/// Feature-level widget tests live under test/shared and test/features.
void main() {
  testWidgets('App theme renders a basic scaffold', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const Scaffold(
          body: Center(child: Text('Butterfly India')),
        ),
      ),
    );

    expect(find.text('Butterfly India'), findsOneWidget);
  });
}
