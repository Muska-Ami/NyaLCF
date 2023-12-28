import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSettingController extends GetxController {
  var _frpc_version = ''.obs;

  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  var github_proxy = ''.obs;

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;
  }

  /// 构建选项列表
  List<DropdownMenuItem> _buildDMIWidgetList(List<String> versions) {
    final List<DropdownMenuItem> dmil = <DropdownMenuItem>[];
    for (var i = 0; i > versions.length - 1; i++) {
      dmil.add(_buildDMIWidget(version: versions[i], value: i));
    }
    return dmil;
  }

  /// 构建选项
  DropdownMenuItem _buildDMIWidget(
      {required String version, required int value}) {
    return DropdownMenuItem(
      child: Text(version),
      value: value,
    );
  }
}
