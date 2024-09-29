// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/frpc/frpc.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/frpc/archive.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';

final _fcs = FrpcConfigurationStorage();
final FrpcSettingController _fsCtr = Get.find();

Widget frpcDownloadDialog(BuildContext context) {
  return SimpleDialog(
    title: const Text('请选择一个合适的架构'),
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only(
            left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
        child: Column(
          children: <Widget>[
            Text('猫猫翻遍了系统变量，识别到 CPU 架构为：${_fsCtr.cpuArch}'),
            Obx(() => DropdownButton(
                  value: _fsCtr.frpcDownloadArch.value,
                  items: _fsCtr.frpcDownloadArchList,
                  onChanged: (value) {
                    Logger.debug(_fsCtr.arch);
                    Logger.info('Selected arch: ${_fsCtr.arch[value]['arch']}');
                    _fsCtr.frpcDownloadArch.value = value;
                  },
                )),
            ElevatedButton(
              onPressed: () async {
                /// 刷新UI，下载frpc
                _fsCtr.refreshDownloadShow();

                final mirror = _fcs.getSettingsFrpcDownloadMirrorId();

                /// 开始下载
                Get.dialog(_downloading(), barrierDismissible: false);
                _fsCtr.frpcDownloadProgress.value = 0.0;
                _fsCtr.refreshDownloadShow();
                try {
                  final res = await DownloadFrpc.download(
                    arch: _fsCtr.arch[_fsCtr.frpcDownloadArch.value]['arch'],
                    platform: _fsCtr.platform,
                    version: '0.51.3-4',
                    releaseName: 'LoCyanFrp-0.51.3-4 #2024082401',
                    progressCallback: _fsCtr.downloadFrpcCallback,
                    cancelToken: _fsCtr.downloadCancelToken,
                    useMirror: _fcs.getSettingsFrpcDownloadMirror(),
                    mirrorId: mirror.isNotEmpty ? mirror : null,
                  );
                  if (res.status) {
                    res as FrpcDownloadResponse;
                    final resExtract = FrpcArchive.extract(
                      platform: _fsCtr.platform,
                      arch: _fsCtr.arch[_fsCtr.frpcDownloadArch.value]['arch'],
                      version: '0.51.3-4',
                    );
                    if (await resExtract) {
                      Get.close(0);
                      Get.close(0);
                      _fcs.setSettingsFrpcVersion('0.51.3-4');
                      _fcs.addInstalledVersion('0.51.3-4');
                      _fcs.save();
                      _fsCtr.load();
                    }
                    _fsCtr.refreshDownloadShow();
                  } else {
                    if (res is FrpcDownloadResponse && res.cancelled) {
                      _fsCtr.frpcDownloadCancel = true;
                    } else {
                      _fsCtr.frpcDownloadError = res as ErrorResponse;
                    }
                  }
                } catch (e, st) {
                  Logger.error(e, t: st);
                  Get.close(0);
                  Get.snackbar(
                    '下载 Frpc 时发生错误..呜呜..',
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    animationDuration: const Duration(milliseconds: 300),
                  );
                }
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
            Obx(() => Column(children: _fsCtr.frpcDownloadShow.value)),
            Obx(() => Text(
                '进度：${(_fsCtr.frpcDownloadProgress.value * 100).toStringAsFixed(2)}%')),
            ElevatedButton(
              onPressed: () async {
                _fsCtr.downloadCancelToken.cancel();
                _fsCtr.refreshDownloadShow();
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

Widget frpcUnarchiveDialog() {
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
