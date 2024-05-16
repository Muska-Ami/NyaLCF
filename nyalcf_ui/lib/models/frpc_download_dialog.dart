import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/frpc/download.dart';

class FrpcDownloadDialogX {
  FrpcDownloadDialogX({required this.context});

  final BuildContext context;
  final fcs = FrpcConfigurationStorage();
  final FrpcSettingController dsctr = Get.find();

  Widget build() {
    return SimpleDialog(
      title: const Text('请选择一个合适的架构'),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: <Widget>[
              Text('猫猫翻遍了系统变量，识别到 CPU 架构为：${dsctr.cpuArch}'),
              Obx(() => DropdownButton(
                    value: dsctr.frpcDownloadArch.value,
                    items: dsctr.frpcDownloadArchList,
                    onChanged: (value) {
                      Logger.debug(dsctr.arch);
                      Logger.info(
                          'Selected arch: ${dsctr.arch[value]['arch']}');
                      dsctr.frpcDownloadArch.value = value;
                    },
                  )),
              ElevatedButton(
                onPressed: () async {
                  /// 刷新UI，下载frpc
                  dsctr.refreshDownloadShow();

                  /// 开始下载
                  Get.dialog(_downloading(), barrierDismissible: false);
                  final res = await FrpcDownloadDio().download(
                    arch: dsctr.arch[dsctr.frpcDownloadArch.value]['arch'],
                    platform: dsctr.platform,
                    version: '0.51.3-3',
                    progressCallback: dsctr.downloadFrpcCallback,
                    cancelToken: dsctr.downloadCancelToken,
                    useMirror: fcs.getSettingsGitHubMirror(),
                  );
                  dsctr.frpcDownloadCancel = res;
                  dsctr.refreshDownloadShow();
                },
                child: const Text('开始下载'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _downloading() {
    return SimpleDialog(
      title: const Text('正在下载...'),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: <Widget>[
              // ignore: invalid_use_of_protected_member
              Obx(() => Column(children: dsctr.frpcDownloadShow.value)),
              Obx(() => Text(
                  '进度：${(dsctr.frpcDownloadProgress.value * 100).toStringAsFixed(2)}%')),
              ElevatedButton(
                onPressed: () async {
                  dsctr.downloadCancelToken.cancel();
                  dsctr.refreshDownloadShow();
                  Get.close(0);
                },
                child: const Text('取消'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget unarchiving() {
    return SimpleDialog(
      title: const Column(
        children: <Widget>[
          Text('正在解压...'),
          Text(
            '这可能需要几分钟时间，稍安勿躁喵~',
            style: TextStyle(fontSize: 15.0),
          ),
        ],
      ),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: const Column(
            children: <Widget>[
              SizedBox(
                height: 22.0,
                width: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
