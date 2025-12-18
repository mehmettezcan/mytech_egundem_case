import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytech_egundem_case/core/constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  AuthInterceptor(this._prefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final token = _prefs.getString(authTokenEGundem);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
