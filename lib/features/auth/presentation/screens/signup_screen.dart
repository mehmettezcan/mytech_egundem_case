import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/features/auth/di/auth_providers.dart';
import 'package:mytech_egundem_case/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mytech_egundem_case/core/widgets/button.dart';
import 'package:mytech_egundem_case/core/widgets/input.dart';
import 'package:mytech_egundem_case/routes.dart';

class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(authControllerProvider);
    final ctrl = ref.read(authControllerProvider.notifier);

    final showMismatch = st.confirmPassword.isNotEmpty && !st.passwordsMatch;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1220),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Create Your Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Join us to get the latest news updates.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      _Label('Email'),
                      const SizedBox(height: 8),
                      EgundemInput(
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: ctrl.setEmail,
                      ),

                      const SizedBox(height: 14),
                      _Label('Password'),
                      const SizedBox(height: 8),
                      EgundemInput(
                        hint: 'Enter your password',
                        obscureText: st.obscurePassword,
                        onChanged: ctrl.setPassword,
                        suffix: IconButton(
                          onPressed: ctrl.togglePassword,
                          icon: Icon(
                            st.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      _Label('Confirm Password'),
                      const SizedBox(height: 8),
                      EgundemInput(
                        hint: 'Confirm your password',
                        obscureText: st.obscureConfirmPassword,
                        onChanged: ctrl.setConfirmPassword,
                        errorBorder: showMismatch,
                        suffix: IconButton(
                          onPressed: ctrl.toggleConfirmPassword,
                          icon: Icon(
                            st.obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),

                      if (showMismatch) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Passwords do not match.',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                          ),
                        ),
                      ],

                      if (st.error != null && !showMismatch) ...[
                        const SizedBox(height: 10),
                        Text(
                          st.error!,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      EgundemButton(
                        onPressed:
                            st.isSubmitting
                                ? null
                                : () async {
                                  await ctrl.submitSignup(
                                    onSignup: ({
                                      required email,
                                      required password,
                                    }) async {
                                      final authProvider = await ref.read(
                                        authRepositoryProvider.future,
                                      );
                                      await authProvider.signup(
                                        email: email,
                                        password: password,
                                      );

                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RouteGenerator.loginScreen,
                                        );
                                      }
                                    },
                                  );
                                },
                        isLoading: st.isSubmitting,
                        child: const Text(
                          'Create Account',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                          ),
                          children: const [
                            TextSpan(
                              text: 'By creating an account, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(color: Color(0xFF60A5FA)),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(color: Color(0xFF60A5FA)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                RouteGenerator.loginScreen,
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFF60A5FA),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.75),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
