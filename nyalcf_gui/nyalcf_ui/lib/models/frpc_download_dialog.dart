import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/frpc/frpc.dart';

class FrpcDownloadDialogX {
  FrpcDownloadDialogX({required this.context});

  final BuildContext context;
  final _fcs = FrpcConfigurationStorage();
  final FrpcSettingController _dsCtr = Get.find();

  Widget build() {
    return SimpleDialog(
      title: const Text('请选择一个合适的架构'),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: <Widget>[
              Text('猫猫翻遍了系统变量，识别到 CPU 架构为：${_dsCtr.cpuArch}'),
              Obx(() => DropdownButton(
                    value: _dsCtr.frpcDownloadArch.value,
                    items: _dsCtr.frpcDownloadArchList,
                    onChanged: (value) {
                      Logger.debug(_dsCtr.arch);
                      Logger.info(
                          'Selected arch: ${_dsCtr.arch[value]['arch']}');
                      _dsCtr.frpcDownloadArch.value = value;
                    },
                  )),
              ElevatedButton(
                onPressed: () async {
                  /// 刷新UI，下载frpc
                  _dsCtr.refreshDownloadShow();

                  final mirror = _fcs.getSettingsFrpcDownloadMirrorId();

                  /// 开始下载
                  Get.dialog(_downloading(), barrierDismissible: false);
                  final res = await DownloadFrpc.download(
                    arch: _dsCtr.arch[_dsCtr.frpcDownloadArch.value]['arch'],
                    platform: _dsCtr.platform,
                    version: '0.51.3-3',
                    releaseName: 'LoCyanFrp-0.51.3-3 #2024050701',
                    progressCallback: _dsCtr.downloadFrpcCallback,
                    cancelToken: _dsCtr.downloadCancelToken,
                    useMirror: _fcs.getSettingsFrpcDownloadMirror(),
                    mirrorId: mirror.isNotEmpty ? mirror : null,
                  );
                  _dsCtr.frpcDownloadCancel = res;
                  _dsCtr.refreshDownloadShow();
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
              Obx(() => Column(children: _dsCtr.frpcDownloadShow.value)),
              Obx(() => Text(
                  '进度：${(_dsCtr.frpcDownloadProgress.value * 100).toStringAsFixed(2)}%')),
              ElevatedButton(
                onPressed: () async {
                  _dsCtr.downloadCancelToken.cancel();
                  _dsCtr.refreshDownloadShow();
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
