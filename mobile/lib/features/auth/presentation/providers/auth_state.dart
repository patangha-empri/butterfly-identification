import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AUTH UI STATE (sealed union — Freezed)
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
sealed class AuthUiState with _$AuthUiState {
  const factory AuthUiState.initial() = _AuthUiStateInitial;
  const factory AuthUiState.loading() = _AuthUiStateLoading;
  const factory AuthUiState.success(UserEntity user) = _AuthUiStateSuccess;
  const factory AuthUiState.error(
    String message, {
    @Default({}) Map<String, String> fieldErrors,
  }) = _AuthUiStateError;

  const AuthUiState._();

  bool get isLoading => this is _AuthUiStateLoading;
  bool get isSuccess => this is _AuthUiStateSuccess;
  bool get hasError => this is _AuthUiStateError;

  String? get errorMessage => switch (this) {
    _AuthUiStateError(:final message) => message,
    _ => null,
  };

  /// Server-provided field-level errors keyed by form field
  /// (e.g. {'email': 'An account with this email already exists.'}).
  Map<String, String> get fieldErrors => switch (this) {
    _AuthUiStateError(:final fieldErrors) => fieldErrors,
    _ => const {},
  };

  UserEntity? get user => switch (this) {
    _AuthUiStateSuccess(:final user) => user,
    _ => null,
  };
}
