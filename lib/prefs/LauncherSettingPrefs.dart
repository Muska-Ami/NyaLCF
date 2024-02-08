import 'package:nyalcf/io/launcherSettingStorage.dart';
import 'package:nyalcf/models/LauncherSettingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LauncherSettingPrefs {
  static Future<void> setInfo(LauncherSettingModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setting@theme@auto', data.theme_auto);
    prefs.setBool('setting@theme@dark@enable', data.theme_dark);
    prefs.setBool(
        'setting@theme@light@seed@enable', data.theme_light_seed_enable);
    prefs.setString('setting@theme@light@seed@value', data.theme_light_seed);
  }

  static Future<LauncherSettingModel> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final theme_auto = prefs.getBool('setting@theme@auto') ?? true;
    final theme_dark = prefs.getBool('setting@theme@dark@enable') ?? false;
    final theme_light_seed_enable =
        prefs.getBool('setting@theme@light@seed@enable') ?? false;
    final theme_light_seed =
        prefs.getString('setting@theme@light@seed@value') ?? '';
    return LauncherSettingModel(
      theme_auto: theme_auto,
      theme_dark: theme_dark,
      theme_light_seed: theme_light_seed,
      theme_light_seed_enable: theme_light_seed_enable,
    );
  }

  static Future<void> refresh() async {
    final res = await LauncherSettingStorage.read();
    if (res != null) setInfo(res);
  }

  static Future<void> setThemeAuto(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setting@theme@auto', value);
  }

  static Future<void> setThemeDark(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setting@theme@dark@enable', value);
  }
}
