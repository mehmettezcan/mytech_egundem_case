import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/features/auth/states/auth_state.dart';

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void setEmail(String v) => state = state.copyWith(email: v, error: null);
  void setPassword(String v) => state = state.copyWith(password: v, error: null);
  void setConfirmPassword(String v) =>
      state = state.copyWith(confirmPassword: v, error: null);

  void togglePassword() =>
      state = state.copyWith(obscurePassword: !state.obscurePassword);

  void toggleConfirmPassword() =>
      state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);

  void clearError() => state = state.copyWith(error: null);

  bool _isValidEmail(String s) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);

  String? _validateLogin() {
    if (!_isValidEmail(state.email)) return 'Please enter a valid email.';
    if (state.password.isEmpty) return 'Password is required.';
    return null;
  }

  String? _validateSignup() {
    if (!_isValidEmail(state.email)) return 'Please enter a valid email.';
    if (state.password.length < 6) return 'Password must be at least 6 characters.';
    if (!state.passwordsMatch) return 'Passwords do not match.';
    return null;
  }

  Future<void> submitSignup({
    required Future<void> Function({
      required String email,
      required String password,
    }) onSignup,
  }) async {
    final err = _validateSignup();
    if (err != null) {
      state = state.copyWith(error: err);
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await onSignup(email: state.email.trim(), password: state.password);
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }

  Future<void> submitLogin({
    required Future<void> Function({
      required String email,
      required String password,
    }) onLogin,
  }) async {
    final err = _validateLogin();
    if (err != null) {
      state = state.copyWith(error: err);
      return;
    }

    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await onLogin(email: state.email.trim(), password: state.password);
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
  
  void reset() => state = const AuthState();
}
