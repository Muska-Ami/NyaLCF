import 'package:package_info_plus/package_info_plus.dart';

class Universe {
  static late final String appName;
  static late final String appPackageName;
  static late final String appVersion;
  static late final String appBuildNumber;

  static Future<void> loadUniverse() async {
    final packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    appPackageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    appBuildNumber = packageInfo.buildNumber;
  }
}
