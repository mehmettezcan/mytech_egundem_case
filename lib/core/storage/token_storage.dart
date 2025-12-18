import 'package:mytech_egundem_case/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TokenStorage {
  final SharedPreferences _prefs;

  TokenStorage(this._prefs);

  Future<void> saveAccessToken(String token) async {
    await _prefs.setString(authTokenEGundem, token);
  }

  String? get accessToken => _prefs.getString(authTokenEGundem);

  Future<void> clear() async {
    await _prefs.remove(authTokenEGundem);
  }
}
