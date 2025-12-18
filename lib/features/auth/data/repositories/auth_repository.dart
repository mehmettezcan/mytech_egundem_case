import 'package:dio/dio.dart';
import 'package:mytech_egundem_case/core/network/api_client.dart';
import 'package:mytech_egundem_case/core/network/endpoints.dart';
import 'package:mytech_egundem_case/core/storage/token_storage.dart';
import 'package:mytech_egundem_case/features/auth/data/dto/auth_request.dart';
import 'package:mytech_egundem_case/features/auth/data/dto/auth_response.dart';

class AuthRepository {
  final ApiClient _api;
  final TokenStorage _tokenStorage;

  AuthRepository(this._api, this._tokenStorage);

  Future<void> signup({required String email, required String password}) async {
    try {
        await _api.post(
        Endpoints.users,
        data: AuthRequest(email: email, password: password).toJson(),
      );

      return;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Signup failed.');
        }
      }

      final status = e.response?.statusCode;

      if (status == 409) throw Exception('This email is already in use.');
      if (status == 422) throw Exception('Invalid email or password.');
      if (status == 500) throw Exception('Server error. Please try again.');

      throw Exception('Signup failed.');
    }
  }

  Future<void> getUserProfile() async {
    try {
      await _api.get(Endpoints.profile);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Failed to fetch user profile.');
        }
      }

      final status = e.response?.statusCode;

      if (status == 401) throw Exception('Unauthorized. Please log in again.');
      if (status == 500) throw Exception('Server error. Please try again.');

      throw Exception('Failed to fetch user profile.');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final response = await _api.post(
        Endpoints.signIn,
        data: AuthRequest(email: email, password: password).toJson(),
      );
      
      final loginResponse = AuthResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      await _tokenStorage.saveAccessToken(loginResponse.accessToken);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          throw Exception(data['message'] ?? 'Login failed.');
        }
      }

      final status = e.response?.statusCode;

      if (status == 401) throw Exception('Invalid email or password.');
      if (status == 500) throw Exception('Server error. Please try again.');

      throw Exception('Login failed.');
    }
  }
}
