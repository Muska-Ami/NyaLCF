import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSettingLauncherController extends GetxController {

  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;
  }

}
