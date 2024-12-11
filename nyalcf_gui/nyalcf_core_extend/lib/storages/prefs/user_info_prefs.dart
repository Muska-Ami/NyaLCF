// Package imports:
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core_extend/storages/prefs/instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPrefs {

  static Future<void> setInfo(UserInfoModel userInfo) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setInt('user_id', userInfo.id);
    await prefs.setString('user_name', userInfo.username);
    await prefs.setString('user_email', userInfo.email);
    await prefs.setString('user_avatar', userInfo.avatar);
    await prefs.setInt('user_inbound', userInfo.inbound);
    await prefs.setInt('user_outbound', userInfo.outbound);
    await prefs.setString('user_traffic', userInfo.traffic.toString());
  }

  static Future<void> setInbound(int inbound) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setInt('user_inbound', inbound);
  }

  static Future<void> setOutbound(int outbound) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setInt('user_outbound', outbound);
  }

  static Future<void> setTraffic(num traffic) async {
    SharedPreferences prefs = await PrefsInstance.instance;
    await prefs.setString('user_traffic', traffic.toString());
  }

  static Future<void> saveToFile() async {
    await UserInfoStorage.save(await getInfo());
  }

  static Future<UserInfoModel> getInfo() async {
    SharedPreferences prefs = await PrefsInstance.instance;
    int id = prefs.getInt('user_id') ?? 0;
    String username = prefs.getString('user_name') ?? '';
    String email = prefs.getString('user_email') ?? '';
    String avatar = prefs.getString('user_avatar') ?? 'https://cravatar.cn/avatar/';
    int inbound = prefs.getInt('user_inbound') ?? 0;
    int outbound = prefs.getInt('user_outbound') ?? 0;
    num traffic = num.parse(prefs.getString('user_traffic') ?? '0');
    return UserInfoModel(
      username: username,
      id: id,
      email: email,
      avatar: avatar,
      inbound: inbound,
      outbound: outbound,
      traffic: traffic,
    );
  }
}
