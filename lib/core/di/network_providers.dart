import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/di/app_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mytech_egundem_case/core/di/env_providers.dart';
import 'package:mytech_egundem_case/core/di/logging_providers.dart';
import 'package:mytech_egundem_case/core/di/interceptor/auth_interceptor.dart';
import 'package:mytech_egundem_case/core/di/interceptor/dio_interceptor.dart';
import 'package:mytech_egundem_case/core/di/interceptor/ssl.dart'
    show CustomSslCertificateInterceptor;
import 'package:mytech_egundem_case/core/network/api_client.dart';

part 'network_providers.g.dart';

@riverpod
CustomSslCertificateInterceptor sslInterceptor(Ref ref) {
  return CustomSslCertificateInterceptor();
}

@riverpod
Future<AuthInterceptor> authInterceptor(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthInterceptor(prefs);
}

@riverpod
DioLoggingInterceptor diologInterceptor(Ref ref) {
  final env = ref.read(envProvider);
  final logger = ref.read(logProvider('DioLoggingInterceptor'));
  return DioLoggingInterceptor(enabled: env.isDev, loggy: logger);
}

@riverpod
Future<Dio> dio(Ref ref) async {
  final env = ref.read(envProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: env.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': env.xApiKey,
      },
    ),
  );

  final auth = await ref.watch(authInterceptorProvider.future);

  dio.interceptors.addAll([
    auth,
    ref.read(diologInterceptorProvider),
    ref.read(sslInterceptorProvider),
  ]);

  return dio;
}

@riverpod
Future<ApiClient> apiClient(Ref ref) async {
  final dio = await ref.watch(dioProvider.future);
  final loggy = ref.read(logProvider('ApiClient'));
  return ApiClient(dio: dio, loggy: loggy);
}
