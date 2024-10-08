// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class TokenModePrefs {
  static Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token_mode@frp_token', value);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final frpToken = prefs.getString('token_mode@frp_token');
    return frpToken;
  }
}
