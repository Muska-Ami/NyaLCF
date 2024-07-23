import 'dart:io';

import 'package:nyalcf_core/storages/json_configuration.dart';

class LauncherConfigurationStorage extends JsonConfiguration {
  @override
  File get file => File('$path/launcher.json');

  @override
  String get handle => 'LAUNCHER';

  @override
  Future<Map<String, dynamic>> get defConfig async => {
        'debug': false,
        'theme': {
          'auto': true,
          'dark': {
            'enable': false,
          },
          'light': {
            'seed': {
              'enable': false,
              'value': '66ccff',
            },
          }
        },
        'auto_sign': false,
      };

  bool getDebug() =>
      (Platform.environment['NYA_LCF_DEBUG'] == 'true' ? true : null) ??
      cfg.getBool('debug');

  void setDebug(bool value) => cfg.setBool('debug', value);

  bool getThemeAuto() => cfg.getBool('theme.auto');

  void setThemeAuto(bool value) => cfg.setBool('theme.auto', value);

  bool getThemeDarkEnable() => cfg.getBool('theme.dark.enable');

  void setThemeDarkEnable(bool value) =>
      cfg.setBool('theme.dark.enable', value);

  bool getThemeLightSeedEnable() => cfg.getBool('theme.light.seed.enable');

  void setThemeLightSeedEnable(bool value) =>
      cfg.setBool('theme.light.seed.enable', value);

  String getThemeLightSeedValue() => cfg.getString('theme.light.seed.value');

  void setThemeLightSeedValue(String value) =>
      cfg.setString('theme.light.seed.value', value);

  bool getAutoSign() => cfg.getBool('auto_sign');

  void setAutoSign(bool value) => cfg.setBool('auto_sign', value);
}
