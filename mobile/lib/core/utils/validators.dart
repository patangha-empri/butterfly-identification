/// ─────────────────────────────────────────────────────────────────────────────
/// FORM VALIDATORS
/// Pure functions returning null (valid) or an error message (invalid).
/// Compatible with TextFormField.validator signature.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );
  static final _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');

  // ── Email ───────────────────────────────────────────────────────────────────
  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  // ── Password (login — lenient) ──────────────────────────────────────────────
  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // ── Password (register — strong) ────────────────────────────────────────────
  static String? strongPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Use at least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Add an uppercase letter';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Add a lowercase letter';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Add a number';
    return null;
  }

  // ── Confirm password ────────────────────────────────────────────────────────
  static String? Function(String?) confirmPassword(String original) =>
      (value) {
        if (value == null || value.isEmpty) return 'Please confirm your password';
        if (value != original) return 'Passwords do not match';
        return null;
      };

  // ── Full name ───────────────────────────────────────────────────────────────
  static String? fullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Name is required';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 60) return 'Name is too long';
    return null;
  }

  // ── Username ────────────────────────────────────────────────────────────────
  static String? username(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username is required';
    if (!_usernameRegex.hasMatch(v)) {
      return '3–20 characters: letters, numbers, underscore';
    }
    return null;
  }

  // ── Required (generic) ──────────────────────────────────────────────────────
  static String? Function(String?) required([String field = 'This field']) =>
      (value) => (value == null || value.trim().isEmpty)
          ? '$field is required'
          : null;

  /// Password strength 0..1 for the strength meter.
  static double passwordStrength(String value) {
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (value.length >= 12) score++;
    if (value.contains(RegExp(r'[A-Z]'))) score++;
    if (value.contains(RegExp(r'[0-9]'))) score++;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return (score / 5).clamp(0.0, 1.0);
  }
}
