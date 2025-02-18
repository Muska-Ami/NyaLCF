// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
// Project imports:
import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_ui/models/frpc_download_dialog.dart';

class FrpcDownloadTip {
  static final _fcs = FrpcConfigurationStorage();
  static final FrpcSettingController _fsCtr = Get.find();

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

  static Future<Card> notFound({required context}) async => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.warning),
              title: Text('指定的 Frpc 版本不可用，请尝试重新安装 o.o'),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Frpc 好像不见了，无法启动隧道了...呜呜...'),
                  SelectableText(
                    '期望的 Frpc 文件路径：'
                    '${await FrpcPathProvider.frpcPath(skipCheck: true)}',
                  ),
                  const Text('可是猫猫没有发现它！'),
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _frpcSelector(),
                        Row(
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
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  _fsCtr.installedFrpcVersions.remove(
                                    _fcs.getSettingsFrpcVersion(),
                                  );
                                  _fcs.removeInstalledVersion(
                                    _fcs.getSettingsFrpcVersion(),
                                  );
                                  _fcs.save();
                                  _fsCtr.load();
                                },
                                child: const Text('移除'),
                              ),
                            ),
                          ],
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
                      'Frpc 文件路径：${await FrpcPathProvider.frpcPath() ?? '未找到'}'),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _frpcSelector(),
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

  static Widget _frpcSelector() => Row(
        children: <Widget>[
          const Expanded(
            child: ListTile(
              leading: Icon(Icons.label_important),
              title: Text('选择使用的 Frpc 版本'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 40),
            child: Obx(
              () => DropdownButton<String>(
                value: _fsCtr.selectedFrpc.value,
                onChanged: (value) {
                  Logger.debug('Selected frpc version: $value');
                  if (value != null) {
                    _fcs.setSettingsFrpcVersion(value);
                    _fsCtr.selectedFrpc.value = value;
                    _fcs.save();
                    _fsCtr.load();
                  }
                },
                items:
                    _fsCtr.installedFrpcVersions.map<DropdownMenuItem<String>>(
                  (value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
}
