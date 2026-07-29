import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_scaffold.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FORGOT PASSWORD SCREEN
/// Submits a reset request, then shows a confirmation state.
/// ─────────────────────────────────────────────────────────────────────────────

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitting = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    unawaited(Haptics.medium());

    final result = await ref
        .read(authRepositoryProvider)
        .forgotPassword(_emailController.text.trim());

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (failure) {
        Haptics.error();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(failure.message),
            backgroundColor: ColorTokens.error,
            behavior: SnackBarBehavior.floating,
          ));
      },
      (_) {
        Haptics.success();
        setState(() => _sent = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) return _buildSuccess(context);

    return AuthScaffold(
      title: 'Reset password',
      subtitle: 'Enter your email and we’ll send you a reset link.',
      showBackButton: true,
      onBack: () => context.pop(),
      children: [
        Form(
          key: _formKey,
          child: AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: _emailController,
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: Validators.email,
            enabled: !_submitting,
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(height: SpaceTokens.xl),
        AppButton(
          label: 'Send Reset Link',
          onPressed: _submitting ? null : _submit,
          isLoading: _submitting,
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpaceTokens.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorTokens.success.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.mark_email_read_outlined,
                    size: 44, color: ColorTokens.success),
              ),
              const SizedBox(height: SpaceTokens.xl),
              Text(
                'Check your email',
                style: TypographyTokens.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SpaceTokens.sm),
              Text(
                'We sent a reset link to\n${_emailController.text.trim()}',
                textAlign: TextAlign.center,
                style: TypographyTokens.textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: SpaceTokens.xxl),
              AppButton(
                label: 'Back to Sign In',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
