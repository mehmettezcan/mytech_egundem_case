import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:mytech_egundem_case/core/widgets/button.dart';
import 'package:mytech_egundem_case/core/widgets/input.dart';
import 'package:mytech_egundem_case/features/auth/di/auth_providers.dart';
import 'package:mytech_egundem_case/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mytech_egundem_case/routes.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(authControllerProvider);
    final ctrl = ref.read(authControllerProvider.notifier);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign in or create an account to continue',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      _label('Email Address'),
                      EgundemInput(
                        hint: 'Enter your email',
                        onChanged: ctrl.setEmail,
                      ),

                      const SizedBox(height: 16),
                      _label('Password'),
                      EgundemInput(
                        hint: 'Enter your password',
                        obscureText: st.obscurePassword,
                        onChanged: ctrl.setPassword,
                        suffix: IconButton(
                          icon: Icon(
                            st.obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: ctrl.togglePassword,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // forgot password
                          },
                          child: const Text('Forgot Password?', style: TextStyle(
                            color: AppColors.primaryColor,
                          )),
                        ),
                      ),

                      if (st.error != null)
                        Text(
                          st.error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),

                      const SizedBox(height: 12),

                      EgundemButton(
                        onPressed:
                            st.isSubmitting
                                ? null
                                : () async {
                                  await ctrl.submitLogin(
                                    onLogin: ({
                                      required email,
                                      required password,
                                    }) async {
                                      final authProvider = await ref.read(
                                        authRepositoryProvider.future,
                                      );

                                      await authProvider.login(
                                        email: email,
                                        password: password,
                                      );

                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          RouteGenerator.selectSourceScreen,
                                        );
                                      }
                                    },
                                  );
                                },
                        child:
                            st.isSubmitting
                                ? const CircularProgressIndicator(
                                  strokeWidth: 2,
                                )
                                : const Text('Sign In'),
                      ),

                      const SizedBox(height: 12),

                      EgundemButton(
                        onPressed: () async {
                          Navigator.pushNamed(
                            context,
                            RouteGenerator.signUpScreen,
                          );
                        },
                        isFlat: true,
                        child: const SizedBox(
                          width: double.infinity,
                          child: Center(child: Text('Sign Up')),
                        ),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(t, style: TextStyle(color: Colors.white.withOpacity(0.75))),
  );
}
