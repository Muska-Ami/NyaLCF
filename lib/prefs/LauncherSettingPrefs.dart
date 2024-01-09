import 'package:nyalcf/io/settingStorage.dart';
import 'package:nyalcf/model/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LauncherSettingPrefs {
  static Future<void> setInfo(Setting data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setting@theme@auto', data.theme_auto.toString());
    prefs.setString('setting@theme@dark@enable', data.theme_dark.toString());
    prefs.setString('setting@theme@light@seed@enable',
        data.theme_light_seed_enable.toString());
    prefs.setString('setting@theme@light@seed@value', data.theme_light_seed);
  }

  static Future<Setting> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final theme_auto = prefs.getString('setting@theme@auto') ?? 'true';
    final theme_dark = prefs.getString('setting@theme@dark@enable') ?? 'false';
    final theme_light_seed_enable =
        prefs.getString('setting@theme@light@seed@enable') ?? 'false';
    final theme_light_seed =
        prefs.getString('setting@theme@light@seed@value') ?? '';
    return Setting(
      theme_auto: theme_auto.toBoolean(),
      theme_dark: theme_dark.toBoolean(),
      theme_light_seed: theme_light_seed,
      theme_light_seed_enable: theme_light_seed_enable.toBoolean(),
    );
  }

  static Future<void> refresh() async {
    final res = await SettingStorage.read();
    if (res != null) setInfo(res);
  }
}

extension on String {
  bool toBoolean() {
    print(this);
    return (this.toLowerCase() == 'true' || this.toLowerCase() == '1')
        ? true
        : (this.toLowerCase() == 'false' || this.toLowerCase() == '0'
            ? false
            : throw UnsupportedError);
  }
}
