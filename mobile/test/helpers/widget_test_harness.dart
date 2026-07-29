import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// WIDGET TEST HARNESS
/// Wraps widgets-under-test in a themed MaterialApp with controllable
/// brightness, text scale and reduced-motion for accessibility tests.
/// ─────────────────────────────────────────────────────────────────────────────

Widget wrapForTest(
  Widget child, {
  Brightness brightness = Brightness.light,
  double textScale = 1.0,
  bool reduceMotion = false,
  Size? size,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode:
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    home: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: reduceMotion,
        size: size ?? const Size(400, 800),
      ),
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

/// Pumps a widget in both light + dark and runs [expectations] for each.
Future<void> testBothThemes(
  WidgetTester tester,
  Widget child,
  Future<void> Function(Brightness) expectations,
) async {
  for (final brightness in Brightness.values) {
    await tester.pumpWidget(wrapForTest(child, brightness: brightness));
    await tester.pump();
    await expectations(brightness);
  }
}
