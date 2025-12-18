import 'package:dio/dio.dart';

class CustomSslCertificateInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}
