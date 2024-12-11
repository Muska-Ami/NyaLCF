import 'package:nyalcf_core_extend/storages/prefs/instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInfoPrefs {

  static Future<void> setRefreshToken(String refreshToken) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setString('refresh_token', refreshToken);
  }
  static Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await PrefsInstance.instance;
    return prefs.getString('refresh_token');
  }

  static Future<void> setAccessToken(String accessToken) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setString('access_token', accessToken);
  }
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await PrefsInstance.instance;
    return prefs.getString('access_token');
  }

  static Future<void> setFrpToken(String frpToken) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setString('frp_token', frpToken);
  }

  static Future<String?> getFrpToken() async {
    SharedPreferences prefs = await PrefsInstance.instance;
    return prefs.getString('frp_token');
  }
}