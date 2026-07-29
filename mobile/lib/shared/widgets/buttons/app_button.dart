import 'package:flutter/material.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/a11y.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP BUTTON
/// Primary interactive button with variants, loading state, icons and haptics.
/// ─────────────────────────────────────────────────────────────────────────────

enum AppButtonVariant { primary, secondary, outline, ghost, danger, accent }

enum AppButtonSize { small, medium, large }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.enableHaptics = true,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final bool enableHaptics;
  final String? semanticLabel;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DurationTokens.instant,
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = _controller.drive(Tween(begin: 1.0, end: 0.96));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  void _handleTap() {
    if (!widget._enabled) return;
    if (widget.enableHaptics) Haptics.light();
    widget.onPressed!.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);
    final dims = _resolveDimensions();

    final content = widget.isLoading
        ? SizedBox(
            height: dims.iconSize,
            width: dims.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation(colors.foreground),
            ),
          )
        : Row(
            mainAxisSize:
                widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: dims.iconSize, color: colors.foreground),
                SizedBox(width: dims.gap),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: dims.textStyle.copyWith(color: colors.foreground),
                ),
              ),
              if (widget.trailingIcon != null) ...[
                SizedBox(width: dims.gap),
                Icon(widget.trailingIcon,
                    size: dims.iconSize, color: colors.foreground),
              ],
            ],
          );

    return Semantics(
      button: true,
      enabled: widget._enabled,
      label: widget.semanticLabel ?? widget.label,
      child: GestureDetector(
        onTapDown: widget._enabled ? _onTapDown : null,
        onTapUp: widget._enabled ? _onTapUp : null,
        onTapCancel: widget._enabled ? _onTapCancel : null,
        onTap: _handleTap,
        child: ScaleTransition(
          scale: _scale,
          child: AnimatedOpacity(
            duration: DurationTokens.fast,
            opacity: widget._enabled ? 1.0 : 0.5,
            child: Container(
              height: dims.height,
              width: widget.isFullWidth ? double.infinity : null,
              padding: EdgeInsets.symmetric(horizontal: dims.paddingH),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: RadiusTokens.buttonBR,
                border: colors.border != null
                    ? Border.all(color: colors.border!, width: 1.5)
                    : null,
                boxShadow: colors.shadow,
                gradient: colors.gradient,
              ),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonColors _resolveColors(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (widget.variant) {
      AppButtonVariant.primary => const _ButtonColors(
          background: ColorTokens.brandPrimary,
          foreground: Colors.white,
          shadow: ShadowTokens.brand,
        ),
      AppButtonVariant.secondary => const _ButtonColors(
          background: ColorTokens.brandSecondary,
          foreground: Colors.white,
        ),
      AppButtonVariant.accent => const _ButtonColors(
          background: null,
          gradient: ColorTokens.accentGradient,
          foreground: Colors.white,
          shadow: ShadowTokens.accent,
        ),
      AppButtonVariant.outline => _ButtonColors(
          background: Colors.transparent,
          foreground: scheme.primary,
          border: scheme.outline,
        ),
      AppButtonVariant.ghost => _ButtonColors(
          background: Colors.transparent,
          foreground: scheme.primary,
        ),
      AppButtonVariant.danger => const _ButtonColors(
          background: ColorTokens.error,
          foreground: Colors.white,
        ),
    };
  }

  _ButtonDimensions _resolveDimensions() {
    return switch (widget.size) {
      AppButtonSize.small => const _ButtonDimensions(
          height: 40,
          paddingH: SpaceTokens.base,
          iconSize: 16,
          gap: SpaceTokens.xs,
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      AppButtonSize.medium => const _ButtonDimensions(
          height: 48,
          paddingH: SpaceTokens.lg,
          iconSize: 18,
          gap: SpaceTokens.sm,
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      AppButtonSize.large => const _ButtonDimensions(
          height: 54,
          paddingH: SpaceTokens.xl,
          iconSize: 20,
          gap: SpaceTokens.sm,
          textStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
    };
  }
}

class _ButtonColors {
  const _ButtonColors({
    this.background,
    required this.foreground,
    this.border,
    this.shadow,
    this.gradient,
  });
  final Color? background;
  final Color foreground;
  final Color? border;
  final List<BoxShadow>? shadow;
  final Gradient? gradient;
}

class _ButtonDimensions {
  const _ButtonDimensions({
    required this.height,
    required this.paddingH,
    required this.iconSize,
    required this.gap,
    required this.textStyle,
  });
  final double height;
  final double paddingH;
  final double iconSize;
  final double gap;
  final TextStyle textStyle;
}
