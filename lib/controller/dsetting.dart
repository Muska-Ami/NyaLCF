import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/model/FrpcConfig.dart';
import 'package:nyalcf/prefs/SettingPrefs.dart';
import 'package:nyalcf/ui/model/FrpcDownloadDialog.dart';
import 'package:nyalcf/ui/model/FrpcDownloadTip.dart';
import 'package:nyalcf/util/CPUArch.dart';
import 'package:nyalcf/util/frpc/Archive.dart';
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
  var frpc_download_show = <Widget>[].obs;
  var _frpc_downloaded_versions = [];
  dynamic frpc_download_cancel = false;

  var frpc_version = ''.obs;

  var app_name = ''.obs;
  var app_version = ''.obs;
  var app_package_name = ''.obs;

  var github_proxy = ''.obs;

  var cpu_arch = ''.obs;

  load() async {
    final packageInfo = await PackageInfo.fromPlatform();
    app_name.value = packageInfo.appName;
    app_version.value = packageInfo.version;
    app_package_name.value = packageInfo.packageName;

    cpu_arch.value = await CPUArch.getCPUArchitecture();

    frpc_version.value = await FrpcManagerStorage.usingVersion;
    _load_tip();
    _load_frpc_dropdownitem();
  }

  void _load_tip() async {
    _frpc_downloaded_versions = await FrpcManagerStorage.downloadedVersions;
    if (_frpc_downloaded_versions.length == 0) {
      frpc_download_tip.value = FrpcDownloadTip.tip(context: context);
    } else {
      frpc_download_tip.value = await FrpcDownloadTip.downloaded(context: context);
    }
  }

  /// 加载Frpc下载列表
  void _load_frpc_dropdownitem() {
    frpc_download_arch_list.value = _buildArchDMIWidgetList();
    print(frpc_download_arch_list);
  }

  void refreshDownloadShow() async {
    if (frpc_download_cancel is bool) {
      if (frpc_download_cancel) {
        frpc_download_show.clear();
        frpc_download_show.add(Text(
          '下载取消',
          style: TextStyle(color: Colors.orange),
        ));
      } else {
        frpc_download_show.clear();
        frpc_download_show.add(LinearProgressIndicator(
          value: frpc_download_progress.value,
        ));
      }
    } else if (frpc_download_cancel is Response) {
      Navigator.of(context).pop();
      /*await showDialog(
          context: context,
          builder: (context) {
            return FrpcDownloadDialogX(context: context).unarchiving();
          });*/
      Get.dialog(FrpcDownloadDialogX(context: context).unarchiving(), barrierDismissible: false);
      Future.delayed(const Duration(milliseconds: 3000), () async {
        //延时执行
        final unarchive = await FrpcArchive.unarchive(
          platform: platform,
          arch: arch[frpc_download_arch.value]['arch'],
          version: '0.51.3',
        );
        if (unarchive) {
          SettingPrefs.setFrpcDownloadedVersionsInfo('0.51.3');
          FrpcManagerStorage.save(
            FrpcConfig(
                settings: (await SettingPrefs.getFrpcInfo()).settings,
                lists: (await SettingPrefs.getFrpcInfo()).lists),
          );
          if (!Platform.isWindows) {
            await FrpcManagerStorage.setRunPermission();
          }
          _load_tip();
        } else {
          Get.snackbar(
            '解压 Frpc 时发生错误..呜呜..',
            '请检查磁盘是否被塞满了..或者是已经安装了！受不了了呜呜呜...',
            snackPosition: SnackPosition.BOTTOM,
            animationDuration: Duration(milliseconds: 300),
          );
        }
        /// 关闭对话框
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
    } else {
      frpc_download_show.clear();
      frpc_download_show.add(Text(
        '发生错误',
        style: TextStyle(color: Colors.red),
      ));
      Get.snackbar(
        '下载 Frpc 时发生错误..呜呜..',
        frpc_download_cancel.toString(),
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 300),
      );
    }
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
    if (total != -1) {
      if (!downloadCancelToken.isCancelled) {
        frpc_download_progress.value = received / total;
      } else {
        frpc_download_progress.value = -1;
      }
    } else {
      print('Download failed: file total is -1');
    }
    refreshDownloadShow();
  }
}
