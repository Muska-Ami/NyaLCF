import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSettingController extends GetxController {
  var frpc_download_tip = Container().obs;
  var frpc_version = ''.obs;

  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  var github_proxy = ''.obs;

  var _frpc_downloaded_versions = [];

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;

    frpc_version.value = await FrpcManagerStorage.usingVersion;
    _load_tip();
  }

  void _load_tip() async {
    _frpc_downloaded_versions = await FrpcManagerStorage.downloadedVersions;
    if (_frpc_downloaded_versions.length == 0) {
      frpc_download_tip.value = Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('尚未安装任何版本的 Frpc'),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('无法启动隧道了...呜呜...'),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {},
                            child: Text('下载'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void _load_frpc_dropdown_item() {
    /// TODO: 加载Frpc下载列表
  }

  /// 构建选项列表
  /// TODO: 重写添加系统判定输出对应下载选项
  List<DropdownMenuItem> _buildDMIWidgetList(List<String> versions) {
    final List<DropdownMenuItem> dmil = <DropdownMenuItem>[];
    for (var i = 0; i > versions.length - 1; i++) {
      dmil.add(_buildDMIWidget(version: versions[i], value: i));
    }
    return dmil;
  }

  /// 构建选项
  DropdownMenuItem _buildDMIWidget({
    required String version,
    required int value,
  }) {
    return DropdownMenuItem(
      child: Text(version),
      value: value,
    );
  }
}
