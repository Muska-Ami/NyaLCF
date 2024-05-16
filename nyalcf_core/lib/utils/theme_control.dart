import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ThemeControl {
  static final lcs = LauncherConfigurationStorage();

  /// 设置主题为自动模式
  static void autoSet() {
    final bool isDarkMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    switchDarkTheme(isDarkMode);
  }

  /// 切换到暗色主题
  static void switchDarkTheme(bool value) {
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
      Logger.info('切换到暗色主题');
    } else {
      if (lcs.getThemeLightSeedEnable()) {
        Get.changeThemeMode(ThemeMode.light);
        Get.changeTheme(custom);
        Logger.info('切换到亮色主题，种子：${lcs.getThemeLightSeedValue()}');
      } else {
        Get.changeThemeMode(ThemeMode.light);
        Get.changeTheme(light);
        Logger.info('切换到亮色主题');
      }
    }
    Get.forceAppUpdate();
  }

  /// 暗色主题设置
  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'HarmonyOS Sans',
    brightness: Brightness.dark,
  );

  /// 亮色主题设置
  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'HarmonyOS Sans',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink.shade300,
    ).copyWith(
      primary: Colors.pink.shade400,
      secondary: Colors.pink.shade300,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.pink.shade100,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink.shade200,
    ),
  );
  static final custom = ThemeData(
    useMaterial3: true,
    fontFamily: 'HarmonyOS Sans',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: colorFromHexCode(lcs.getThemeLightSeedValue()),
    ),
    appBarTheme: AppBarTheme(
      color: colorFromHexCode(lcs.getThemeLightSeedValue()),
    ),
  );

  static colorFromHexCode(String code) {
    Logger.debug(code);
    if (code.startsWith('#')) {
      code = code.substring(1); // 移除 # 符号
    }

    if (code.length == 6) {
      // 如果是 6 位十六进制颜色代码
      return Color(int.parse(code, radix: 16) + 0xFF000000);
    } else if (code.length == 8) {
      // 如果是 8 位十六进制颜色代码（包含透明度）
      return Color(int.parse(code, radix: 16));
    } else {
      throw UnimplementedError('Could not translate String into hex color');
    }
  }
}
