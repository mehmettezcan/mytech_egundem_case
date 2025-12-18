class AuthState {
  final String email;
  final String password;
  final String confirmPassword;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  final bool isSubmitting;
  final String? error;

  const AuthState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.isSubmitting = false,
    this.error,
  });

  bool get passwordsMatch =>
      password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword;

  AuthState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? isSubmitting,
    String? error,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}