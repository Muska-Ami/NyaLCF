import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/theme_control.dart';

class DSettingLauncherController extends GetxController {
  final lcs = LauncherConfigurationStorage();

  var themeAuto = false.obs;
  var themeDark = false.obs;
  var themeLightSeed = ''.obs;
  var themeLightSeedEnable = false.obs;

  var switchThemeDark = const Row().obs;

  var debugMode = false.obs;

  load() async {
    themeLightSeed.value = lcs.getThemeLightSeedValue();
    themeLightSeedEnable.value = lcs.getThemeLightSeedEnable();
    // 新配置
    themeAuto.value = lcs.getThemeAuto();
    themeDark.value = lcs.getThemeDarkEnable();
    debugMode.value = lcs.getDebug();
    loadx();
  }

  void loadx() {
    if (!(themeAuto.value)) {
      Logger.debug('Auto theme is disabled, add button to switch theme');
      switchThemeDark.value = Row(
        children: <Widget>[
          const Expanded(
            child: ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('深色主题'),
            ),
          ),
          Switch(
            value: themeDark.value,
            onChanged: switchDarkTheme,
          ),
        ],
      );
    } else {
      switchThemeDark.value = const Row();
    }
  }

  void switchDarkTheme(value) async {
    lcs.setThemeDarkEnable(value);
    lcs.save();
    themeDark.value = value;
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      if (lcs.getThemeLightSeedEnable()) Get.changeTheme(ThemeControl.custom);
    }
    Get.forceAppUpdate();
    loadx();
    // ThemeControl.switchDarkTheme(value);
  }
}
