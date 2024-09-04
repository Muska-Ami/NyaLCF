import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_ui/models/frpc_download_dialog.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';

class FrpcDownloadTip {
  static final _fcs = FrpcConfigurationStorage();
  static final FrpcSettingController _fSCtr = Get.find();

  static Future<Card> tip({required context}) async => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning),
              title: Text('尚未安装任何版本的 Frpc'),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('无法启动隧道了...呜呜...'),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return frpcDownloadDialog(context);
                                });
                          },
                          child: const Text('下载'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  static Future<Widget> downloaded({required context}) async => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('可用的 Frpc 版本已安装！素晴らしい！'),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('已安装版本列表：'),
                  Text(_fcs.getInstalledVersions().toString()),
                  SelectableText(
                      'Frpc 文件路径：${await FrpcPathProvider().frpcPath ?? '未找到'}'),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return frpcDownloadDialog(context);
                          });
                    },
                    child: const Text('重新下载'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
