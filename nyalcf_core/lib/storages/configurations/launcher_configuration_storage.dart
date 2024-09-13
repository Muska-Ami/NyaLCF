// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';

// Project imports:
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

  /// 获取是否开启 DEBUG
  bool getDebug() => ENV_UNIVERSAL_DEBUG ?? cfg.getBool('debug');

  /// 设置是否开启 DEBUG
  /// [value] 是否开启 DEBUG
  void setDebug(bool value) => cfg.setBool('debug', value);

  /// 获取是否自动设置主题
  bool getThemeAuto() => cfg.getBool('theme.auto');

  /// 设置自动设置主题
  /// [value] 是否自动设置主题
  void setThemeAuto(bool value) => cfg.setBool('theme.auto', value);

  /// 获取是否启用暗色模式
  bool getThemeDarkEnable() => cfg.getBool('theme.dark.enable');

  /// 设置是否启用暗色模式
  /// [value] 是否启用暗色模式
  void setThemeDarkEnable(bool value) =>
      cfg.setBool('theme.dark.enable', value);

  /// 获取是否浅色模式自定义主题色
  bool getThemeLightSeedEnable() => cfg.getBool('theme.light.seed.enable');

  /// 设置浅色模式自定义主题色
  /// [value] 是否使用自定义主题色
  void setThemeLightSeedEnable(bool value) =>
      cfg.setBool('theme.light.seed.enable', value);

  /// 获取浅色模式主题色种子
  String getThemeLightSeedValue() => cfg.getString('theme.light.seed.value');

  /// 设置浅色模式主题色种子
  /// [value] 16 进制颜色代码
  void setThemeLightSeedValue(String value) =>
      cfg.setString('theme.light.seed.value', value);

  /// 获取是否启用自动签到
  bool getAutoSign() => cfg.getBool('auto_sign');

  /// 设置是否启用自动签到
  /// [value] 是否启用自动签到
  void setAutoSign(bool value) => cfg.setBool('auto_sign', value);
}
