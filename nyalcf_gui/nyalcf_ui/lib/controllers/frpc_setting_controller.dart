import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:nyalcf_core/models/response/template/error_model.dart';

import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/cpu_arch.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/frpc/arch.dart';
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
  bool frpcDownloadCancel = false;
  ErrorResponse? frpcDownloadError;
  var frpcDownloadUseMirror = false.obs;
  var frpcDownloadMirror = ''.obs;

  var frpcVersion = ''.obs;

  var cpuArch = ''.obs;

  var downloadMirrors = [];
  var selectedMirror = 'muska-github-mirror'.obs;

  load() async {
    cpuArch.value = (await CPUArch.getCPUArchitecture())!;
    // await FrpcSettingPrefs.refresh();
    // final frpcinfo = await FrpcSettingPrefs.getFrpcInfo();
    frpcDownloadUseMirror.value = _fcs.getSettingsFrpcDownloadMirror();

    frpcVersion.value = _fcs.getSettingsFrpcVersion();
    downloadMirrors = _fcs.getDownloadMirrors();
    selectedMirror.value = _fcs.getSettingsFrpcDownloadMirrorId();
    _loadTip();
    _loadFrpcDropdownItem();
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
  void _loadFrpcDropdownItem() {
    frpcDownloadArchList.value = _buildArchDMIWidgetList();
    Logger.debug(frpcDownloadArchList);
  }

  void refreshDownloadShow() async {
    if (frpcDownloadCancel) {
      Logger.debug('Download cancelled.');
      frpcDownloadShow.clear();
      frpcDownloadShow.add(const Text(
        '下载取消',
        style: TextStyle(color: Colors.orange),
      ));
      frpcDownloadCancel = false;
      downloadCancelToken = CancelToken();
    } else if (frpcDownloadError != null) {
      frpcDownloadShow.clear();
      frpcDownloadShow.add(Text(
        '发生错误：${frpcDownloadError!.message}',
        style: const TextStyle(color: Colors.red),
      ));
    } else {
      frpcDownloadShow.clear();
      frpcDownloadShow.add(LinearProgressIndicator(
        value: frpcDownloadProgress.value,
      ));
    }
    }

  /// 构建Arch列表
  List<DropdownMenuItem<dynamic>> _buildArchDMIWidgetList() {
    List<Map<String, String>> arch = [];
    final List<DropdownMenuItem<dynamic>> dmil = <DropdownMenuItem<dynamic>>[];

    /// Platform = Windows
    if (Platform.isWindows) {
      platform = 'windows';
      Logger.info('Build windows platform arch list');
      arch.addAll(Arch.windows);
    }

    /// Platform = Linux
    if (Platform.isLinux) {
      platform = 'linux';
      Logger.info('Build linux platform arch list');
      arch.addAll(Arch.linux);
    }

    /// Platform = MacOS
    if (Platform.isMacOS) {
      platform = 'darwin';
      Logger.info('Build macos platform arch list');
      arch.addAll(Arch.macos);
    }
    this.arch = arch;

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
      if (!frpcDownloadCancel) {
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
