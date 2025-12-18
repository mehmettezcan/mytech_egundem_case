import 'package:dio/dio.dart';
import 'package:loggy/loggy.dart';

class ApiClient{
  final Dio _dio;
  final bool debug;
  final Loggy _loggy;

  ApiClient({required Dio dio, this.debug = true, required Loggy loggy}) : _dio = dio, _loggy = loggy;

  String _endpoint(String path) => path;

  void _logRequest(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    Options? options,
  }) {
    if (!debug) return;

    final baseUrl = _dio.options.baseUrl;

    final headers = <String, dynamic>{
      ..._dio.options.headers,
      ...?options?.headers,
    };

    Object? safeData = data;
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      if (m.containsKey('password')) m['password'] = '***';
      if (m.containsKey('refresh_token')) m['refresh_token'] = '***';
      safeData = m;
    }
    
    _loggy.debug('''
➡️ REQUEST
METHOD : $method
URL    : $baseUrl$path
HEADERS: $headers
QUERY  : $query
BODY   : $safeData
''');
  }

  void _logResponse(Response res) {
    if (!debug) return;

    _loggy.debug('''
⬅️ RESPONSE
STATUS : ${res.statusCode}
URL    : ${res.requestOptions.uri}
DATA   : ${res.data}
''');
  }

  void _logError(DioException e) {
    if (!debug) return;

    _loggy.error('''
❌ ERROR
URL    : ${e.requestOptions.uri}
STATUS : ${e.response?.statusCode}
DATA   : ${e.response?.data}
TYPE   : ${e.type}
MESSAGE: ${e.message}
''');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logRequest('GET', path, query: queryParameters, options: options);
    try {
      final res = await _dio.get<T>(
        _endpoint(path),
        queryParameters: queryParameters,
        options: options,
      );
      _logResponse(res);
      return res;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logRequest(
      'POST',
      path,
      data: data,
      query: queryParameters,
      options: options,
    );

    try {
      final res = await _dio.post<T>(
        _endpoint(path),
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _logResponse(res);
      return res;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logRequest(
      'PUT',
      path,
      data: data,
      query: queryParameters,
      options: options,
    );

    try {
      final res = await _dio.put<T>(
        _endpoint(path),
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _logResponse(res);
      return res;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    _logRequest(
      'DELETE',
      path,
      data: data,
      query: queryParameters,
      options: options,
    );

    try {
      final res = await _dio.delete<T>(
        _endpoint(path),
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      _logResponse(res);
      return res;
    } on DioException catch (e) {
      _logError(e);
      rethrow;
    }
  }
}
