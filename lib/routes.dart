import 'package:flutter/material.dart';
import 'package:mytech_egundem_case/features/auth/presentation/screens/login_screen.dart';
import 'package:mytech_egundem_case/features/sources/presentation/screens/select_source_screen.dart';
import 'package:mytech_egundem_case/features/auth/presentation/screens/signup_screen.dart';
import 'package:mytech_egundem_case/features/auth/presentation/screens/splash_screen.dart';
import 'package:mytech_egundem_case/features/home/presentation/screens/home_screen.dart';

class RouteGenerator {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String signUpScreen = '/signup';
  static const String selectSourceScreen = '/select-source';
  static const String homeScreen = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case signUpScreen:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
        
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case selectSourceScreen:
        return MaterialPageRoute(builder: (_) => const SelectSourceScreen());

      case homeScreen:
        return MaterialPageRoute(builder: (_) => const  HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Sayfa bulunamadı')),
          ),
        );
    }
  }
}
