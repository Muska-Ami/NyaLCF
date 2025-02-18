// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/cpu_arch.dart';
import 'package:nyalcf_core/utils/frpc/arch.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf_ui/models/frpc_download_tip.dart';

class FrpcSettingController extends GetxController {
  FrpcSettingController({required this.context});

  final FrpcConfigurationStorage _fcs = FrpcConfigurationStorage();

  /// BuildContext
  BuildContext context;

  /// Frpc 架构列表
  List<Map<String, dynamic>> arch = <Map<String, dynamic>>[];

  /// 目标平台
  String platform = '';

  // String? get customPath => Platform.environment['NYA_LCF_FRPC_PATH'];

  /// <Rx>Frpc 下载提示卡片组件
  Rx<Widget> frpcDownloadTip = const Card().obs;

  /// <Rx>Frpc 下载架构选择组件
  var frpcDownloadArchList = <DropdownMenuItem<dynamic>>[
    const DropdownMenuItem<dynamic>(value: 0, child: Text('加载中')),
  ].obs;

  /// <Rx>Frpc 下载架构选择组件绑定 ID
  var frpcDownloadArch = 0.obs;

  /// <Rx>Frpc 下载进度
  var frpcDownloadProgress = 0.0.obs;

  /// <Rx>Frpc 下载进度条等展示
  var frpcDownloadShow = <Widget>[].obs;

  /// 是否取消下载 Frpc
  bool frpcDownloadCancel = false;

  /// <Rx>是否使用镜像源
  var frpcDownloadUseMirror = false.obs;

  /// <Rx>Frpc 版本
  var frpcVersion = ''.obs;

  /// <Rx>CPU架构
  var cpuArch = ''.obs;

  /// 下载镜像源列表
  var downloadMirrors = [];

  /// <Rx>选择的镜像源
  var selectedMirror = 'muska-github-mirror'.obs;

  /// <Rx> 选择使用的 Frpc
  var installedFrpcVersions = [''];

  /// <Rx> 选择使用的 Frpc
  var selectedFrpc = ''.obs;

  /// 加载控制器
  load() async {
    cpuArch.value = (await CPUArch.getCPUArchitecture())!;
    frpcDownloadUseMirror.value = _fcs.getSettingsFrpcDownloadMirror();

    frpcVersion.value = _fcs.getSettingsFrpcVersion();
    downloadMirrors = _fcs.getDownloadMirrors();
    selectedMirror.value = _fcs.getSettingsFrpcDownloadMirrorId();
    Logger.info(_fcs.getInstalledVersions());
    installedFrpcVersions = _fcs.getInstalledVersions();
    if (selectedFrpc.value != '' &&
        !installedFrpcVersions.contains(selectedFrpc.value)) {
      installedFrpcVersions.add(selectedFrpc.value);
    }
    selectedFrpc.value = _fcs.getSettingsFrpcVersion();
    _loadTip();
    _loadFrpcDropdownItem();
  }

  /// 加载 Frp Client 下载提示信息
  void _loadTip() async {
    if (_fcs.getInstalledVersions().isNotEmpty) {
      if (await FrpcPathProvider.frpcPath() == null) {
        if (context.mounted) {
          frpcDownloadTip.value =
              await FrpcDownloadTip.notFound(context: context);
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
    } else {
      frpcDownloadTip.value = await FrpcDownloadTip.tip(context: context);
    }
  }

  /// 加载 Frp Client 下载列表
  void _loadFrpcDropdownItem() {
    frpcDownloadArchList.value = _buildArchDMIWidgetList();
    Logger.debug(frpcDownloadArchList);
  }

  /// 刷新 Frp Client 下载进度条展示等内容
  void refreshProgress() async {
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
  }

  /// 构建 Arch 列表
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

  /// 取消下载的 CancelToken
  static CancelToken downloadCancelToken = CancelToken();

  /// 下载 Frp Client 回调函数
  void downloadFrpClientCallback(received, total) {
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
    refreshProgress();
  }

  void downloadFailed(Object e) {
    frpcDownloadShow.add(const Text(
      '下载错误',
      style: TextStyle(color: Colors.orange),
    ));
    frpcDownloadShow.add(Text(
      e.toString(),
      style: TextStyle(color: Colors.orange),
    ));
    downloadCancelToken = CancelToken();
  }
}
