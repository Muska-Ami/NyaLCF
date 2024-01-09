import 'package:get/get.dart';
import 'package:nyalcf/prefs/LauncherSettingPrefs.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSettingLauncherController extends GetxController {
  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  var theme_auto = false.obs;
  var theme_dark = false.obs;
  var theme_light_seed = ''.obs;
  var theme_light_seed_enable = false.obs;

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;

    final settings = await LauncherSettingPrefs.getInfo();
    theme_auto.value = settings.theme_auto;
    theme_dark.value = settings.theme_dark;
    theme_light_seed.value = settings.theme_light_seed;
    theme_light_seed_enable.value = settings.theme_light_seed_enable;
  }
}
