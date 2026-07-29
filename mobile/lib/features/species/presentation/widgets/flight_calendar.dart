import 'package:flutter/material.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FLIGHT CALENDAR
/// 12-month activity strip; active flight months are highlighted.
/// ─────────────────────────────────────────────────────────────────────────────

class FlightCalendar extends StatelessWidget {
  const FlightCalendar({super.key, required this.activeMonths});

  /// 1-based month numbers (1 = Jan … 12 = Dec).
  final List<int> activeMonths;

  static const _labels = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D',
  ];

  @override
  Widget build(BuildContext context) {
    final active = activeMonths.toSet();
    return Semantics(
      label: 'Flight activity calendar',
      child: Row(
        children: List.generate(12, (i) {
          final month = i + 1;
          final isActive = active.contains(month);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: DurationTokens.normal,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isActive
                          ? ColorTokens.brandPrimary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(RadiusTokens.sm),
                    ),
                    alignment: Alignment.center,
                    child: isActive
                        ? const Icon(Icons.flutter_dash,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: SpaceTokens.xs),
                  Text(
                    _labels[i],
                    style: TypographyTokens.caption.copyWith(
                      color: isActive
                          ? ColorTokens.brandPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
