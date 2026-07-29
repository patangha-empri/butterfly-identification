import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/color_tokens.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/theme/typography_tokens.dart';
import '../../../../core/utils/a11y.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_scaffold.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// LOGIN SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.redirect});

  final String? redirect;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      Haptics.medium();
      ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  /// Dismiss the server error banner/field errors once the user edits input.
  void _clearServerError() {
    if (ref.read(authNotifierProvider).hasError) {
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final isLoading = state.isLoading;

    // ── Side-effects: navigate on success, snackbar on error ────────────────
    ref.listen<AuthUiState>(authNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        Haptics.success();
        context.go(widget.redirect ?? AppRoutes.home);
      } else if (next.hasError) {
        Haptics.error();
      }
    });

    final fieldErrors = state.fieldErrors;

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to continue your butterfly journey.',
      children: [
        AuthErrorBanner(message: state.hasError ? state.errorMessage : null),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: _emailController,
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                enabled: !isLoading,
                errorText: fieldErrors['email'],
                onChanged: (_) => _clearServerError(),
              ),
              const SizedBox(height: SpaceTokens.base),
              AppTextField(
                label: 'Password',
                hint: 'Your password',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.password,
                enabled: !isLoading,
                errorText: fieldErrors['password'],
                onChanged: (_) => _clearServerError(),
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading
                ? null
                : () => context.push(AppRoutes.forgotPassword),
            child: const Text('Forgot password?'),
          ),
        ),
        const SizedBox(height: SpaceTokens.sm),
        AppButton(
          label: 'Sign In',
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
        ),
        const SizedBox(height: SpaceTokens.xl),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: isLoading ? null : () => context.push(AppRoutes.register),
              child: Text(
                'Sign Up',
                style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                  color: ColorTokens.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
