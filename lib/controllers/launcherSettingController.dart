import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/storages/configurations/LauncherConfigurationStorage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:nyalcf/utils/Logger.dart';

class DSettingLauncherController extends GetxController {
  final lcs = LauncherConfigurationStorage();

  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  var theme_auto = false.obs;
  var theme_dark = false.obs;
  var theme_light_seed = ''.obs;
  var theme_light_seed_enable = false.obs;

  var switch_theme_dark = Row().obs;

  var debug_mode = false.obs;

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;

    theme_light_seed.value = lcs.getThemeLightSeedValue();
    theme_light_seed_enable.value = lcs.getThemeLightSeedEnable();
    // 新配置
    theme_auto.value = lcs.getThemeAuto();
    theme_dark.value = lcs.getThemeDarkEnable();
    debug_mode.value = lcs.getDebug();
    loadx();
  }

  void loadx() {
    if (!(theme_auto.value)) {
      Logger.debug('Auto theme is disabled, add button to switch theme');
      switch_theme_dark.value = Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('深色主题'),
            ),
          ),
          Switch(
            value: theme_dark.value,
            onChanged: switchDarkTheme,
          ),
        ],
      );
    } else {
      switch_theme_dark.value = Row();
    }
  }

  void switchDarkTheme(value) async {
    lcs.setThemeDarkEnable(value);
    lcs.save();
    theme_dark.value = value;
    if (value)
      Get.changeThemeMode(ThemeMode.dark);
    else
      Get.changeThemeMode(ThemeMode.light);
    Get.forceAppUpdate();
    loadx();
    // ThemeControl.switchDarkTheme(value);
  }
}
