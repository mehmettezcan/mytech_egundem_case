import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';

class DioLoggingInterceptor extends Interceptor {
  final Loggy _log;
  final bool enabled;
  final int maxBodyChars;

  DioLoggingInterceptor({
    Loggy? loggy,
    this.enabled = true,
    this.maxBodyChars = 2000,
  }) : _log = loggy ?? Loggy('DioLoggingInterceptor');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) return handler.next(options);

    _log.debug('→ ${options.method} ${options.uri}');
    _log.debug('Headers: ${_sanitizeHeaders(options.headers)}');

    if (options.queryParameters.isNotEmpty) {
      _log.debug('Query: ${_truncate(options.queryParameters.toString())}');
    }

    if (options.data != null) {
      _log.debug('Body: ${_truncate(_safeToString(options.data))}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) return handler.next(response);

    _log.debug('← ${response.statusCode} ${response.requestOptions.uri}');
    if (response.data != null) {
      _log.debug('Data: ${_truncate(_safeToString(response.data))}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) return handler.next(err);

    final uri = err.requestOptions.uri;
    _log.debug('⨯ ${err.response?.statusCode} $uri');
    _log.debug('Type: ${err.type}  Message: ${err.message}');

    final data = err.response?.data;
    if (data != null) {
      _log.debug('ErrorBody: ${_truncate(_safeToString(data))}');
    }

    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = <String, dynamic>{}..addAll(headers);

    const sensitiveKeys = {
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
      'api-key',
      'x-auth-token',
    };

    for (final key in headers.keys) {
      final lower = key.toLowerCase();
      if (sensitiveKeys.contains(lower)) {
        sanitized[key] = '***';
      }
    }
    return sanitized;
  }

  String _truncate(String text) {
    if (text.length <= maxBodyChars) return text;
    return '${text.substring(0, maxBodyChars)}... (truncated)';
  }

  String _safeToString(dynamic value) {
    try {
      return value.toString();
    } catch (_) {
      return '<unprintable>';
    }
  }
}
