import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class InfoCache {

  static Future<void> setInfo(User userinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", userinfo.user);
    prefs.setString("user_email", userinfo.email);
    prefs.setString("user_token", userinfo.token);
    prefs.setString("user_avatar", userinfo.avatar);
  }

  static Future<User> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user   = prefs.getString("user_name") ?? "";
    String email  = prefs.getString("user_email") ?? "";
    String token  = prefs.getString("user_token") ?? "";
    String avatar = prefs.getString("user_avatar") ?? "";
    return User(
      user: user,
      email: email,
      token: token,
      avatar: avatar
    );
  }

  static void reset() {
    //_userinfo = null;
  }
}
