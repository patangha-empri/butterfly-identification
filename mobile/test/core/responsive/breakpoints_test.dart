import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:butterfly_india/core/responsive/app_breakpoints.dart';

void main() {
  group('AppBreakpoints — configuration', () {
    test('breakpoints list covers 0..infinity', () {
      final breakpoints = AppBreakpoints.breakpoints;
      expect(breakpoints.first.start, 0);
      expect(breakpoints.last.end, double.infinity);
    });

    test('breakpoints are contiguous (no gaps)', () {
      final breakpoints = AppBreakpoints.breakpoints;
      for (int i = 0; i < breakpoints.length - 1; i++) {
        expect(breakpoints[i + 1].start, breakpoints[i].end + 1);
      }
    });

    test('has 5 named breakpoints', () {
      expect(AppBreakpoints.breakpoints.length, 5);
    });
  });

  group('AppBreakpoints — runtime detection', () {
    /// Pumps at [size], captures the resolved breakpoint name + grid columns,
    /// then returns them for assertion OUTSIDE the build phase.
    Future<({String name, int columns})> resolveAt(
      WidgetTester tester,
      Size size,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String name = '';
      int columns = 0;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: Builder(builder: (ctx) {
              name = ResponsiveBreakpoints.of(ctx).breakpoint.name ?? '';
              columns = AppBreakpoints.gridColumns(ctx);
              return const SizedBox.shrink();
            }),
            breakpoints: AppBreakpoints.breakpoints,
          ),
          home: const SizedBox.shrink(),
        ),
      );
      await tester.pump();
      return (name: name, columns: columns);
    }

    testWidgets('detects mobile at 375 wide', (tester) async {
      final result = await resolveAt(tester, const Size(375, 812));
      expect(result.name, AppBreakpoints.mobileTag);
    });

    testWidgets('detects tablet at 768 wide', (tester) async {
      final result = await resolveAt(tester, const Size(768, 1024));
      expect(result.name, AppBreakpoints.tabletTag);
    });

    testWidgets('gridColumns increases with width', (tester) async {
      final mobile = await resolveAt(tester, const Size(375, 812));
      final tablet = await resolveAt(tester, const Size(900, 1200));
      expect(tablet.columns, greaterThanOrEqualTo(mobile.columns));
    });
  });
}
