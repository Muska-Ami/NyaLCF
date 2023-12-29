import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsetting.dart';
import 'package:nyalcf/dio/frpc/download.dart';

class FrpcDownloadDialogX {
  FrpcDownloadDialogX({required this.context});

  final DSettingController ds_c = Get.find();
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return _downloading();
                    },
                    barrierDismissible: false,
                  );
                  FrpcDownloadDio().download(
                      arch: ds_c.arch[ds_c.frpc_download_arch.value]['arch'],
                      platform: ds_c.platform,
                      version: '0.51.3',
                      progressCallback: ds_c.downloadFrpcCallback,
                      cancelToken: ds_c.downloadCancelToken);
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
              Obx(() => LinearProgressIndicator(
                    value: ds_c.frpc_download_progress.value,
                  )),
              Obx(() => Text('进度：${ds_c.frpc_download_progress.value * 100}%')),
              ElevatedButton(
                onPressed: () async {
                  ds_c.downloadCancelToken.cancel();
                  Navigator.of(context).pop();
                },
                child: Text('取消'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
