import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/theme/typography_tokens.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// APP TEXT FIELD
/// Labeled form field with validation, password reveal, prefix icon and a
/// smooth focus highlight. Integrates with Form/TextFormField.
/// ─────────────────────────────────────────────────────────────────────────────

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints,
    this.focusNode,
    this.errorText,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final FocusNode? focusNode;

  /// Server-side error shown beneath the field (overrides validator display
  /// when set). Used for backend errors like "email already exists".
  final String? errorText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TypographyTokens.textTheme.labelMedium?.copyWith(
              color: _focused
                  ? ColorTokens.brandPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SpaceTokens.xs),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscured,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TypographyTokens.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            counterText: '',
            filled: true,
            fillColor: isDark
                ? ColorTokens.surfaceVariantDark
                : ColorTokens.surfaceVariantLight,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: _focused
                        ? ColorTokens.brandPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                : null,
            suffixIcon: _buildSuffix(),
            border: _border(Colors.transparent),
            enabledBorder: _border(Colors.transparent),
            focusedBorder: _border(ColorTokens.brandPrimary, width: 1.6),
            errorBorder: _border(ColorTokens.error),
            focusedErrorBorder: _border(ColorTokens.error, width: 1.6),
            errorStyle: TypographyTokens.textTheme.bodySmall?.copyWith(
              color: ColorTokens.error,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SpaceTokens.base,
              vertical: SpaceTokens.base,
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
        ),
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        onPressed: () => setState(() => _obscured = !_obscured),
        tooltip: _obscured ? 'Show password' : 'Hide password',
      );
    }
    return widget.suffix;
  }

  OutlineInputBorder _border(Color color, {double width = 1.0}) =>
      OutlineInputBorder(
        borderRadius: RadiusTokens.cardBR,
        borderSide: color == Colors.transparent
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );
}
