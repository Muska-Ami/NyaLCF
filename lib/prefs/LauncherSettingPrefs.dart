import 'package:nyalcf/io/settingStorage.dart';
import 'package:nyalcf/model/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LauncherSettingPrefs {
  static Future<void> setFrpcInfo(Setting frpcinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  /*static Future<Setting> getFrpcInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return Setting(

    );
  }*/

  static Future<void> refresh() async {
    final res = await SettingStorage.read();
    if (res != null)
      setFrpcInfo(res);
  }
}
