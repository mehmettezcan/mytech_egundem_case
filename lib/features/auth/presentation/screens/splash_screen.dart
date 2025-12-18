import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:mytech_egundem_case/features/auth/di/auth_providers.dart';
import 'package:mytech_egundem_case/routes.dart';
import 'package:mytech_egundem_case/core/di/storage_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (_navigated) return;
    _navigated = true;

    final tokenStorage = await ref.read(tokenStorageProvider.future);
    final token = tokenStorage.accessToken;

    if (token == null || token.isEmpty) {
      _go(RouteGenerator.loginScreen);
      return;
    }

    try {
      final authProvider = await ref.read(authRepositoryProvider.future);
      await authProvider.getUserProfile();

      _go(RouteGenerator.selectSourceScreen);
    } catch (_) {
      await tokenStorage.clear();
      _go(RouteGenerator.loginScreen);
    }
  }

  void _go(String route) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(
            'assets/logo.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
