import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'env_providers.g.dart';

@riverpod
EnvConfig env(Ref ref) {
  return EnvConfig(
    baseUrl: dotenv.env['BASE_URL']!,
    env: dotenv.env['ENV'] ?? 'dev',
    xApiKey: dotenv.env['XAPIKEY'] ?? '',
  );
}

class EnvConfig {
  final String baseUrl;
  final String xApiKey;
  final String env;

  const EnvConfig({
    required this.baseUrl,
    required this.xApiKey,
    required this.env,
  });

  bool get isProd => env == 'prod';
  bool get isDev => env == 'dev';
}
