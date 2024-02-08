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

  ThemeData getTheme() {
    final bool systemThemeMode = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
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