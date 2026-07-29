import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../shared/widgets/buttons/app_button.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// ONBOARDING SCREEN
/// Emotional multi-page intro. Persists completion flag, then routes to login.
/// ─────────────────────────────────────────────────────────────────────────────

class _OnboardPage {
  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.body,
    required this.color,
  });
  final String emoji;
  final String title;
  final String body;
  final Color color;
}

const _pages = [
  _OnboardPage(
    emoji: '🦋',
    title: 'Discover India’s\nButterflies',
    body: 'Explore 1,500+ species across India — from the Western Ghats to the Himalayas.',
    color: ColorTokens.brandPrimary,
  ),
  _OnboardPage(
    emoji: '📸',
    title: 'Identify with AI',
    body: 'Snap a photo and our AI identifies the species in seconds, with confidence you can trust.',
    color: ColorTokens.brandSecondary,
  ),
  _OnboardPage(
    emoji: '🌿',
    title: 'Contribute to\nScience',
    body: 'Every sighting you log helps map biodiversity and protect fragile habitats.',
    color: ColorTokens.brandAccent,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    await ref.read(appPreferencesProvider).setOnboardingCompleted(true);
    if (mounted) context.go(AppRoutes.login);
  }

  void _next() {
    Haptics.selection();
    if (_isLast) {
      _complete();
    } else {
      _controller.nextPage(
        duration: DurationTokens.normal,
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip ──────────────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: SpaceTokens.sm,
                  top: SpaceTokens.sm,
                ),
                child: TextButton(
                  onPressed: _complete,
                  child: const Text('Skip'),
                ),
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardPageView(page: _pages[i]),
              ),
            ),

            // ── Indicator + CTA ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(SpaceTokens.lg),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: DurationTokens.normal,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: active ? 24 : 8,
                        decoration: BoxDecoration(
                          color: active
                              ? _pages[_index].color
                              : Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: RadiusTokens.pillBR,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: SpaceTokens.xl),
                  AppButton(
                    label: _isLast ? 'Get Started' : 'Next',
                    onPressed: _next,
                    trailingIcon:
                        _isLast ? Icons.check_rounded : Icons.arrow_forward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPageView extends StatelessWidget {
  const _OnboardPageView({required this.page});
  final _OnboardPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: page.color.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: Text(page.emoji, style: const TextStyle(fontSize: 72)),
          )
              .animate(key: ValueKey(page.title))
              .scale(
                duration: 500.ms,
                curve: Curves.easeOutBack,
                begin: const Offset(0.7, 0.7),
                end: const Offset(1, 1),
              )
              .fadeIn(),
          const SizedBox(height: SpaceTokens.xxl),
          Text(
            page.title,
            style: TypographyTokens.textTheme.displaySmall,
          ).animate(key: ValueKey('${page.title}_t')).fadeIn(delay: 150.ms).moveY(begin: 16, end: 0),
          const SizedBox(height: SpaceTokens.base),
          Text(
            page.body,
            style: TypographyTokens.textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ).animate(key: ValueKey('${page.title}_b')).fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
}
