import 'package:nyalcf/models/user_info_model.dart';
import 'package:nyalcf/storages/stores/user_info_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPrefs {
  static Future<void> setInfo(UserInfoModel userinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', userinfo.user);
    prefs.setString('user_email', userinfo.email);
    prefs.setString('user_token', userinfo.token);
    prefs.setString('user_avatar', userinfo.avatar);
    prefs.setInt('user_inbound', userinfo.inbound);
    prefs.setInt('user_outbound', userinfo.outbound);
    prefs.setString('user_frp_token', userinfo.frpToken);
    prefs.setInt('user_traffic', userinfo.traffic);
  }

  static Future<void> setInbound(int inbound) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_inbound', inbound);
  }

  static Future<void> setOutbound(int outbound) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user_outbound', outbound);
  }

  static Future<void> setTraffic(int traffic) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Logger.debug(traffic);
    prefs.setInt('user_traffic', traffic);
  }

  static Future<void> setFrpToken(String frpToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_frp_token', frpToken);
  }

  static Future<void> saveToFile() async {
    await UserInfoStorage.save(await getInfo());
  }

  static Future<UserInfoModel> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user_name') ?? '';
    String email = prefs.getString('user_email') ?? '';
    String token = prefs.getString('user_token') ?? '';
    String avatar =
        prefs.getString('user_avatar') ?? 'https://cravatar.cn/avatar/';
    int inbound = prefs.getInt('user_inbound') ?? 0;
    int outbound = prefs.getInt('user_outbound') ?? 0;
    String frpToken = prefs.getString('user_frp_token') ?? '';
    int traffic = prefs.getInt('user_traffic') ?? 0;
    return UserInfoModel(
      user: user,
      email: email,
      token: token,
      avatar: avatar,
      inbound: inbound,
      outbound: outbound,
      frpToken: frpToken,
      traffic: traffic,
    );
  }
}
