import 'package:shared_preferences/shared_preferences.dart';

class PassPrefs {
  static Future<void> setVersion(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pass@frpc@version', value);
  }

  static Future<String?> getVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final frpToken = prefs.getString('pass@frpc@version');
    return frpToken;
  }
}
