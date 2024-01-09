import 'package:nyalcf/io/settingStorage.dart';
import 'package:nyalcf/model/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LauncherSettingPrefs {
  static Future<void> setFrpcInfo(Setting data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setting@theme@auto', data.theme_auto);
    prefs.setString('setting@theme@dark@enable', data.theme_dark);
    prefs.setString(
        'setting@theme@light@seed@enable', data.theme_light_seed_enable);
    prefs.setString('setting@theme@light@seed@value', data.theme_light_seed);
  }

  static Future<Setting> getFrpcInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final theme_auto = prefs.getString('setting@theme@auto');
    final theme_dark = prefs.getString('setting@theme@dark@enable');
    final theme_light_seed_enable =
        prefs.getString('setting@theme@light@seed@enable');
    final theme_light_seed = prefs.getString('setting@theme@light@seed@value');
    return Setting(
      theme_auto: theme_auto,
      theme_dark: theme_dark,
      theme_light_seed: theme_light_seed,
      theme_light_seed_enable: theme_light_seed_enable,
    );
  }

  static Future<void> refresh() async {
    final res = await SettingStorage.read();
    if (res != null) setFrpcInfo(res);
  }
}
