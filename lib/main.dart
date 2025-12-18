import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytech_egundem_case/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eGündem',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr', 'TR')],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0B1220),

        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          labelStyle: const TextStyle(color: Colors.white),
          floatingLabelStyle: const TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
        ),
      ),
      initialRoute: RouteGenerator.splashScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
