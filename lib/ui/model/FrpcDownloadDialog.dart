import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsettingfrpc.dart';
import 'package:nyalcf/dio/frpc/download.dart';
import 'package:nyalcf/prefs/FrpcSettingPrefs.dart';

class FrpcDownloadDialogX {
  FrpcDownloadDialogX({required this.context});

  final DSettingFrpcController ds_c = Get.find();
  final context;

  Widget build() {
    return SimpleDialog(
      title: const Text('请选择一个合适的架构'),
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: <Widget>[
              Text('猫猫翻遍了系统变量，识别到 CPU 架构为：${ds_c.cpu_arch}'),
              Obx(() => DropdownButton(
                    value: ds_c.frpc_download_arch.value,
                    items: ds_c.frpc_download_arch_list,
                    onChanged: (value) {
                      print('Selected arch: ${ds_c.arch[value]['arch']}');
                      ds_c.frpc_download_arch.value = value;
                    },
                  )),
              ElevatedButton(
                onPressed: () async {
                  /// 刷新UI，下载frpc
                  ds_c.refreshDownloadShow();

                  /// 开始下载
                  Get.dialog(_downloading(), barrierDismissible: false);
                  final res = await FrpcDownloadDio().download(
                      arch: ds_c.arch[ds_c.frpc_download_arch.value]['arch'],
                      platform: ds_c.platform,
                      version: '0.51.3',
                      progressCallback: ds_c.downloadFrpcCallback,
                      cancelToken: ds_c.downloadCancelToken,
                      useMirror:
                          (await FrpcSettingPrefs.getFrpcInfo()).github_mirror);
                  ds_c.frpc_download_cancel = res;
                  ds_c.refreshDownloadShow();
                },
                child: Text('开始下载'),
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
          margin:
              EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: [
              Obx(() => Column(children: ds_c.frpc_download_show.value)),
              Obx(() => Text(
                  '进度：${(ds_c.frpc_download_progress.value * 100).toStringAsFixed(2)}%')),
              ElevatedButton(
                onPressed: () async {
                  ds_c.downloadCancelToken.cancel();
                  Get.close(0);
                },
                child: Text('取消'),
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
        children: [
          Text('正在解压...'),
          Text(
            '这可能需要几分钟时间，稍安勿躁喵~',
            style: TextStyle(fontSize: 15.0),
          ),
        ],
      ),
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
            children: [
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
