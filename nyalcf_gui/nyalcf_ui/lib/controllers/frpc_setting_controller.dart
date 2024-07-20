import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/cpu_arch.dart';
import 'package:nyalcf_core/utils/frpc/archive.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_ui/models/frpc_download_dialog.dart';
import 'package:nyalcf_ui/models/frpc_download_tip.dart';

class FrpcSettingController extends GetxController {
  FrpcSettingController({required this.context});

  BuildContext context;
  List<Map<String, dynamic>> arch = <Map<String, dynamic>>[];
  final FrpcConfigurationStorage _fcs = FrpcConfigurationStorage();

  String platform = '';

  // String? get customPath => Platform.environment['NYA_LCF_FRPC_PATH'];

  Rx<Widget> frpcDownloadTip = const Card().obs;
  var frpcDownloadArchList = <DropdownMenuItem<dynamic>>[
    const DropdownMenuItem<dynamic>(value: 0, child: Text('加载中')),
  ].obs;
  var frpcDownloadArch = 0.obs;
  var frpcDownloadProgress = 0.0.obs;
  var frpcDownloadShow = <Widget>[].obs;
  dynamic frpcDownloadCancel = false;
  var frpcDownloadUseMirror = false.obs;

  var frpcVersion = ''.obs;

  var githubProxy = ''.obs;

  var cpuArch = ''.obs;

  load() async {
    cpuArch.value = (await CPUArch.getCPUArchitecture())!;
    // await FrpcSettingPrefs.refresh();
    // final frpcinfo = await FrpcSettingPrefs.getFrpcInfo();
    frpcDownloadUseMirror.value = _fcs.getSettingsGitHubMirror();

    frpcVersion.value = _fcs.getSettingsFrpcVersion();
    _loadTip();
    _loadFrpcDropdownitem();
  }

  void _loadTip() async {
    if (await FrpcPathProvider().frpcPath == null) {
      if (context.mounted) {
        frpcDownloadTip.value = await FrpcDownloadTip.tip(context: context);
      } else {
        Logger.error('Context not mounted while executing a async function!');
      }
    } else {
      if (context.mounted) {
        frpcDownloadTip.value =
            await FrpcDownloadTip.downloaded(context: context);
      } else {
        Logger.error('Context not mounted while executing a async function!');
      }
    }
  }

  /// 加载Frpc下载列表
  void _loadFrpcDropdownitem() {
    frpcDownloadArchList.value = _buildArchDMIWidgetList();
    Logger.debug(frpcDownloadArchList);
  }

  void refreshDownloadShow() async {
    if (frpcDownloadCancel is bool) {
      if (frpcDownloadCancel) {
        Logger.debug('Download cancelled.');
        frpcDownloadShow.clear();
        frpcDownloadShow.add(const Text(
          '下载取消',
          style: TextStyle(color: Colors.orange),
        ));
        frpcDownloadCancel = false;
        downloadCancelToken = CancelToken();
      } else {
        frpcDownloadShow.clear();
        frpcDownloadShow.add(LinearProgressIndicator(
          value: frpcDownloadProgress.value,
        ));
      }
    } else if (frpcDownloadCancel is Response) {
      Get.close(0);
      /*await showDialog(
          context: context,
          builder: (context) {
            return FrpcDownloadDialogX(context: context).unarchiving();
          });*/
      Get.dialog(FrpcDownloadDialogX(context: context).unarchiving(),
          barrierDismissible: false);
      //延时执行
      Future.delayed(
          const Duration(seconds: 2),
          () => FrpcArchive.unarchive(
                platform: platform,
                arch: arch[frpcDownloadArch.value]['arch'],
                version: _fcs.getSettingsFrpcVersion(),
              ).then((value) async {
                Logger.debug(value);
                if (value) {
                  _fcs.setSettingsFrpcVersion('0.51.3-3');
                  _fcs.addInstalledVersion('0.51.3-3');
                  _fcs.save();
                  /**if (!Platform.isWindows) {
                      print('*nix platform, change file permission');
                      await FrpcManagerStorage.setRunPermission();
                      }*/
                  _loadTip();
                } else {
                  Get.snackbar(
                    '解压 Frpc 时发生错误..呜呜..',
                    '请检查磁盘是否被塞满了..或者是已经安装了！受不了了呜呜呜...',
                    snackPosition: SnackPosition.BOTTOM,
                    animationDuration: const Duration(milliseconds: 300),
                  );
                  Get.close(0);
                }

                _loadTip();

                /// 关闭对话框
                Get.close(0);
                Get.close(0);
              }));
    } else {
      frpcDownloadShow.clear();
      frpcDownloadShow.add(Text(
        '发生错误${frpcDownloadCancel.error}',
        style: const TextStyle(color: Colors.red),
      ));
      Get.snackbar(
        '下载 Frpc 时发生错误..呜呜..',
        frpcDownloadCancel.toString(),
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
  }

  /// 构建Arch列表
  List<DropdownMenuItem<dynamic>> _buildArchDMIWidgetList() {
    dynamic arch = <Map<String, dynamic>>{};
    final List<DropdownMenuItem<dynamic>> dmil = <DropdownMenuItem<dynamic>>[];

    /// Platform = Windows
    if (Platform.isWindows) {
      platform = 'windows';
      Logger.info('Build windows platform arch list');
      arch.addAll([
        {'arch': 'amd64', 'name': 'x86_64/amd64'},
        {'arch': '386', 'name': 'x86/i386/amd32'},
        {'arch': 'arm64', 'name': 'arm64/armv8'},
      ]);
    }

    /// Platform = Linux
    if (Platform.isLinux) {
      platform = 'linux';
      Logger.info('Build linux platform arch list');
      arch.addAll([
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
      Logger.info('Build macos platform arch list');
      arch.addAll([
        {'arch': 'amd64', 'name': 'x86_64/amd64'},
        {'arch': 'arm64', 'name': 'arm64/armv8'},
      ]);
    }
    this.arch = arch.toList();

    /// 遍历构建
    for (var i = 0; i <= this.arch.length - 1; i++) {
      dmil.add(_buildDMIWidget(version: this.arch[i]['name'], value: i));
      Logger.debug(this.arch[i]);
    }
    return dmil;
  }

/*
  /// 构建已下载选项列表
  List<DropdownMenuItem> _buildDownloadedDMIWidgetList(List<String> versions) {
    final List<DropdownMenuItem> dmil = <DropdownMenuItem>[];
    for (var i = 0; i > versions.length - 1; i++) {
      dmil.add(_buildDMIWidget(version: versions[i], value: i));
    }
    return dmil;
  }*/

  /// 构建选项
  DropdownMenuItem _buildDMIWidget({
    required String version,
    required int value,
  }) {
    return DropdownMenuItem(
      value: value,
      child: Text(version),
    );
  }

  CancelToken downloadCancelToken = CancelToken();

  void downloadFrpcCallback(received, total) {
    Logger.debug('Download callback: $received');
    if (total != -1) {
      if (!downloadCancelToken.isCancelled) {
        frpcDownloadProgress.value = received / total;
      } else {
        frpcDownloadProgress.value = -1;
      }
    } else {
      Logger.info('Download failed: file total is -1');
    }
    refreshDownloadShow();
  }
}
