import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/ui/model/FrpcDownloadDialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DSettingController extends GetxController {
  DSettingController({required this.context});

  final context;
  List<Map<String, dynamic>> arch = <Map<String, dynamic>>[];

  var platform = '';

  var frpc_download_tip = Container().obs;
  var frpc_download_arch_list = <DropdownMenuItem>[
    DropdownMenuItem(value: 0, child: Text('加载中')),
  ].obs;
  var frpc_download_arch = 0.obs;
  var frpc_download_progress = 0.0.obs;

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
    _load_frpc_dropdownitem();
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
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return FrpcDownloadDialogX(context: context)
                                        .build();
                                  });
                            },
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

  /// 加载Frpc下载列表
  void _load_frpc_dropdownitem() {
    frpc_download_arch_list.value = _buildArchDMIWidgetList();
    print(frpc_download_arch_list);
  }

  /// 构建Arch列表
  List<DropdownMenuItem> _buildArchDMIWidgetList() {
    final Set<Map<String, dynamic>> _arch = Set();
    final List<DropdownMenuItem> dmil = <DropdownMenuItem>[];

    /// Platform = Windows
    if (Platform.isWindows) {
      platform = 'windows';
      print('Build windows platform arch list');
      _arch.addAll([
        {'arch': 'amd64', 'name': 'x86_64/amd64'},
        {'arch': '386', 'name': 'x86/i386/amd32'},
        {'arch': 'arm64', 'name': 'arm64/armv8'},
      ]);
    }

    /// Platform = Linux
    if (Platform.isLinux) {
      platform = 'linux';
      print('Build linux platform arch list');
      _arch.addAll([
        {'arch': 'amd64', 'name': 'x86_64/amd64'},
        {'arch': '386', 'name': 'x86/i386/amd32'},
        {'arch': 'arm64', 'name': 'arm64/armv8'},
        {'arch': 'arm', 'name': 'arm/armv7/armv6/armv5'},
        {'arch': 'mips64', 'name': 'mips64'},
        {'arch': 'mips', 'name': 'mips'},
        {'arch': 'mips64le', 'name': 'mips64le'},
        {'arch': 'mipsle', 'name': 'mipsle'},
        {'arch': 'riscv64', 'name': 'riscv64'},
      ]);
    }

    /// Platform = MacOS
    if (Platform.isMacOS) {
      platform = 'darwin';
      print('Build macos platform arch list');
      _arch.addAll([
        {'arch': 'amd64', 'name': 'x86_64/amd64'},
        {'arch': 'arm64', 'name': 'arm64/armv8'},
      ]);
    }
    arch = _arch.toList();

    /// 遍历构建
    for (var i = 0; i <= arch.length - 1; i++) {
      dmil.add(_buildDMIWidget(version: arch[i]['name'], value: i));
      print(arch[i]);
    }
    return dmil;
  }

  /// 构建已下载选项列表
  List<DropdownMenuItem> _buildDownloadedDMIWidgetList(List<String> versions) {
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

  final downloadCancelToken = CancelToken();

  void downloadFrpcCallback(received, total) {
    print('Download callback: ${received}');
    if (total != -1) if (!downloadCancelToken.isCancelled) {
      frpc_download_progress.value = received / total;
    } else {
      frpc_download_progress.value = -1;
    }
  }
}
