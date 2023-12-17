import 'package:nyalcf/io/userInfoStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class InfoCache {
  static Future<void> setInfo(User userinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", userinfo.user);
    prefs.setString("user_email", userinfo.email);
    prefs.setString("user_token", userinfo.token);
    prefs.setString("user_avatar", userinfo.avatar);
    prefs.setInt("user_inbound", userinfo.inbound);
    prefs.setInt("user_outbound", userinfo.outbound);
    prefs.setString("user_frp_token", userinfo.frp_token);
    prefs.setInt("user_traffic", userinfo.traffic);
  }

  static Future<void> saveToFile() async {
    await UserInfoStorage.save(await getInfo());
  }

  static Future<User> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString("user_name") ?? "";
    String email = prefs.getString("user_email") ?? "";
    String token = prefs.getString("user_token") ?? "";
    String avatar =
        prefs.getString("user_avatar") ?? "https://cravatar.cn/avatar/";
    int inbound = prefs.getInt("user_inbound") ?? 0;
    int outbound = prefs.getInt("user_outbound") ?? 0;
    String frp_token = prefs.getString("user_frp_token") ?? "";
    int traffic = prefs.getInt("user_traffic") ?? 0;
    return User(
        user: user,
        email: email,
        token: token,
        avatar: avatar,
        inbound: inbound,
        outbound: outbound,
        frp_token: frp_token,
        traffic: traffic);
  }
}
