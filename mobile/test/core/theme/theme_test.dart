import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/theme/app_theme.dart';
import 'package:butterfly_india/core/theme/color_tokens.dart';
import 'package:butterfly_india/core/theme/design_tokens.dart';
import 'package:butterfly_india/core/theme/typography_tokens.dart';

void main() {
  group('AppTheme', () {
    test('light theme uses Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });

    test('dark theme uses Material 3', () {
      expect(AppTheme.dark.useMaterial3, isTrue);
    });

    test('light theme has correct primary color', () {
      expect(AppTheme.light.colorScheme.primary, ColorTokens.brandPrimary);
    });

    test('dark theme has correct surface color', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, ColorTokens.backgroundDark);
    });

    test('both themes have no elevation on AppBar', () {
      expect(AppTheme.light.appBarTheme.elevation, 0);
      expect(AppTheme.dark.appBarTheme.elevation, 0);
    });

    test('card theme has large border radius', () {
      final cardTheme = AppTheme.light.cardTheme;
      expect(cardTheme.shape, isA<RoundedRectangleBorder>());
    });
  });

  group('ColorTokens', () {
    test('brand primary is correct hex', () {
      expect(ColorTokens.brandPrimary.value, const Color(0xFF1F6E5A).value);
    });

    test('AI confidence tiers are distinct colors', () {
      expect(ColorTokens.confidenceCertain, isNot(ColorTokens.confidenceUncertain));
      expect(ColorTokens.confidenceLikely, isNot(ColorTokens.confidencePossible));
    });

    test('lightScheme brightness is light', () {
      expect(ColorTokens.lightScheme.brightness, Brightness.light);
    });

    test('darkScheme brightness is dark', () {
      expect(ColorTokens.darkScheme.brightness, Brightness.dark);
    });
  });

  group('DesignTokens', () {
    test('spacing values are non-negative', () {
      expect(SpaceTokens.xs, greaterThan(0));
      expect(SpaceTokens.massive, greaterThan(SpaceTokens.xl));
    });

    test('radius card > radius sm', () {
      expect(RadiusTokens.card, greaterThan(RadiusTokens.sm));
    });

    test('duration cinematic > normal', () {
      expect(
        DurationTokens.cinematic.inMilliseconds,
        greaterThan(DurationTokens.normal.inMilliseconds),
      );
    });
  });

  group('TypographyTokens', () {
    test('display family is PlayfairDisplay', () {
      expect(TypographyTokens.displayFamily, 'PlayfairDisplay');
    });

    test('body family is Inter', () {
      expect(TypographyTokens.bodyFamily, 'Inter');
    });

    test('displayLarge is larger than bodyLarge', () {
      expect(
        TypographyTokens.textTheme.displayLarge!.fontSize,
        greaterThan(TypographyTokens.textTheme.bodyLarge!.fontSize!),
      );
    });

    test('heroTitle has text shadow', () {
      expect(TypographyTokens.heroTitle.shadows, isNotEmpty);
    });
  });
}
