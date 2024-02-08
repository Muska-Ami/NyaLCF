import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nyalcf/storages/Configuration.dart';
import 'package:nyalcf/utils/ThemeControl.dart';

class LauncherConfigurationStorage extends Configuration {
  @override
  File get file => File('$path/launcher.json');

  @override
  Future<Map<String, dynamic>> get def_config async => {
        'debug': true,
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
      };

  bool getDebug() => cfg.getBool('debug');
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

  ThemeData getTheme() {
    final bool systemThemeMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    final auto = cfg.getBool('theme.auto');
    final dark_enable = cfg.getBool('theme.dark.enable');
    if (auto) {
      switch (systemThemeMode) {
        case true:
          return ThemeControl.dark;
        case false:
          return ThemeControl.light;
      }
    } else if (dark_enable) return ThemeControl.dark;
    return ThemeControl.light;
  }
}
