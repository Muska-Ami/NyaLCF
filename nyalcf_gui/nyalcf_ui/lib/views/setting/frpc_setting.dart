import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';

class FrpcSetting {
  FrpcSetting({required this.context});

  final BuildContext context;
  final _fcs = FrpcConfigurationStorage();
  final FrpcSettingController _dsCtr = Get.find();

  Widget widget() {
    _dsCtr.context = context;
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Obx(() => _dsCtr.frpcDownloadTip.value),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.trip_origin),
                  title: Text('下载源镜像设置'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.auto_awesome),
                                title: Text('启用下载镜像源'),
                              ),
                            ),
                            Switch(
                              value: _dsCtr.frpcDownloadUseMirror.value,
                              onChanged: (value) async {
                                _fcs.setSettingsGitHubMirror(value);
                                _dsCtr.frpcDownloadUseMirror.value = value;
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.auto_awesome),
                                title: Text('选择镜像源'),
                              ),
                            ),
                            // Switch(
                            //   value: _dsCtr.frpcDownloadUseMirror.value,
                            //   onChanged: (value) async {
                            //     _fcs.setSettingsGitHubMirror(value);
                            //     _dsCtr.frpcDownloadUseMirror.value = value;
                            //   },
                            // ),
                          ],
                        ),
                        /// TODO: 镜像选择
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
