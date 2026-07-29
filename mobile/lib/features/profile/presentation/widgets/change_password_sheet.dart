import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/overlays/app_bottom_sheet.dart';
import '../providers/profile_providers.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// CHANGE PASSWORD SHEET
/// ─────────────────────────────────────────────────────────────────────────────

Future<void> showChangePasswordSheet(BuildContext context) {
  return AppBottomSheet.show(
    context,
    title: 'Change password',
    scrollable: false,
    child: const _ChangePasswordBody(),
  );
}

class _ChangePasswordBody extends ConsumerStatefulWidget {
  const _ChangePasswordBody();

  @override
  ConsumerState<_ChangePasswordBody> createState() =>
      _ChangePasswordBodyState();
}

class _ChangePasswordBodyState extends ConsumerState<_ChangePasswordBody> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _localError = null);
    final next = _next.text;
    if (next.length < 8) {
      setState(() => _localError = 'New password must be at least 8 characters.');
      return;
    }
    if (next != _confirm.text) {
      setState(() => _localError = 'Passwords do not match.');
      return;
    }
    FocusScope.of(context).unfocus();
    final ok = await ref.read(changePasswordNotifierProvider.notifier).submit(
          currentPassword: _current.text,
          newPassword: next,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordNotifierProvider);
    final error = _localError ??
        (state.status == PasswordStatus.error ? state.error : null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: 'Current password',
          controller: _current,
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: SpaceTokens.base),
        AppTextField(
          label: 'New password',
          controller: _next,
          obscureText: true,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: SpaceTokens.base),
        AppTextField(
          label: 'Confirm new password',
          controller: _confirm,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        if (error != null) ...[
          const SizedBox(height: SpaceTokens.sm),
          Text(error,
              style: TypographyTokens.textTheme.bodySmall
                  ?.copyWith(color: ColorTokens.error)),
        ],
        const SizedBox(height: SpaceTokens.lg),
        AppButton(
          label: 'Update password',
          onPressed: state.isSaving ? null : _submit,
          isLoading: state.isSaving,
        ),
      ],
    );
  }
}
