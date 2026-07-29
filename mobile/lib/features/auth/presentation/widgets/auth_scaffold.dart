import 'package:flutter/material.dart';
import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/theme/motion_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH SCAFFOLD
/// Shared immersive layout for all auth screens. On phones it's a single
/// scrollable column; on tablets it becomes a two-panel layout with a
/// cinematic brand hero on the left and the form on the right.
/// ─────────────────────────────────────────────────────────────────────────────

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.onBack,
    this.showBackButton = false,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final VoidCallback? onBack;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoints.isTablet(context);

    final form = _AuthForm(
      title: title,
      subtitle: subtitle,
      showBackButton: showBackButton,
      onBack: onBack,
      children: children,
    );

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            const Expanded(flex: 5, child: _BrandHero()),
            Expanded(
              flex: 4,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(SpaceTokens.xxl),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: form,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            SpaceTokens.lg,
            SpaceTokens.lg,
            SpaceTokens.lg,
            SpaceTokens.xxl,
          ),
          child: form,
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.title,
    required this.subtitle,
    required this.children,
    required this.showBackButton,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton)
          IconButton(
            onPressed: onBack ?? () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          )
        else
          const SizedBox(height: SpaceTokens.xl),
        const SizedBox(height: SpaceTokens.lg),
        Text(title, style: TypographyTokens.textTheme.displaySmall)
            .animateEntrance(),
        const SizedBox(height: SpaceTokens.sm),
        Text(
          subtitle,
          style: TypographyTokens.textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ).animateEntrance(index: 1),
        const SizedBox(height: SpaceTokens.xxl),
        ...children,
      ],
    );
  }
}

/// Cinematic brand hero shown on tablet auth layouts.
class _BrandHero extends StatelessWidget {
  const _BrandHero();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: ColorTokens.primaryGradient),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -20,
            child: Icon(
              Icons.flutter_dash,
              size: 280,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SpaceTokens.xxxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/pathanga_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: SpaceTokens.xl),
                Text(
                  'Pathanga',
                  style: TypographyTokens.textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: SpaceTokens.base),
                Text(
                  'Discover, identify and protect\nIndia’s butterflies with AI.',
                  style: TypographyTokens.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
