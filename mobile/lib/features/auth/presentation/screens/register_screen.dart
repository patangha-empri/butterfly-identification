import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
/// REGISTER SCREEN
/// ─────────────────────────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double _passwordStrength = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      Haptics.medium();
      ref.read(authNotifierProvider.notifier).register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
            username: _usernameController.text.trim(),
          );
    }
  }

  /// Dismiss server error banner/field errors once the user edits input.
  void _clearServerError() {
    if (ref.read(authNotifierProvider).hasError) {
      ref.read(authNotifierProvider.notifier).clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final isLoading = state.isLoading;

    ref.listen<AuthUiState>(authNotifierProvider, (prev, next) {
      if (next.isSuccess) {
        Haptics.success();
        context.go(AppRoutes.home);
      } else if (next.hasError) {
        Haptics.error();
      }
    });

    final fieldErrors = state.fieldErrors;

    return AuthScaffold(
      title: 'Create account',
      subtitle: 'Join thousands of butterfly explorers across India.',
      showBackButton: true,
      onBack: () => context.pop(),
      children: [
        AuthErrorBanner(
          message: state.hasError && state.fieldErrors.isEmpty
              ? state.errorMessage
              : null,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'Full name',
                hint: 'Your name',
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: Validators.fullName,
                enabled: !isLoading,
                errorText: fieldErrors['fullName'],
                onChanged: (_) => _clearServerError(),
              ),
              const SizedBox(height: SpaceTokens.base),
              AppTextField(
                label: 'Username',
                hint: 'e.g. butterfly_fan',
                controller: _usernameController,
                prefixIcon: Icons.alternate_email,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
                ],
                validator: Validators.username,
                enabled: !isLoading,
                errorText: fieldErrors['username'],
                onChanged: (_) => _clearServerError(),
              ),
              const SizedBox(height: SpaceTokens.base),
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
                hint: 'Create a strong password',
                controller: _passwordController,
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.strongPassword,
                enabled: !isLoading,
                errorText: fieldErrors['password'],
                onChanged: (v) {
                  _clearServerError();
                  setState(
                      () => _passwordStrength = Validators.passwordStrength(v));
                },
                onSubmitted: (_) => _submit(),
              ),
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: SpaceTokens.sm),
                _PasswordStrengthBar(strength: _passwordStrength),
              ],
            ],
          ),
        ),
        const SizedBox(height: SpaceTokens.xl),
        AppButton(
          label: 'Create Account',
          onPressed: isLoading ? null : _submit,
          isLoading: isLoading,
        ),
        const SizedBox(height: SpaceTokens.base),
        Text(
          'By signing up you agree to our Terms & Privacy Policy.',
          textAlign: TextAlign.center,
          style: TypographyTokens.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: SpaceTokens.lg),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Already have an account? ',
              style: TypographyTokens.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            GestureDetector(
              onTap: isLoading ? null : () => context.pop(),
              child: Text(
                'Sign In',
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

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.strength});
  final double strength;

  Color get _color {
    if (strength < 0.4) return ColorTokens.error;
    if (strength < 0.7) return ColorTokens.warning;
    return ColorTokens.success;
  }

  String get _label {
    if (strength < 0.4) return 'Weak';
    if (strength < 0.7) return 'Fair';
    if (strength < 1.0) return 'Strong';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: strength,
              minHeight: 5,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ),
        const SizedBox(width: SpaceTokens.sm),
        Text(
          _label,
          style: TypographyTokens.textTheme.labelSmall?.copyWith(
            color: _color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
