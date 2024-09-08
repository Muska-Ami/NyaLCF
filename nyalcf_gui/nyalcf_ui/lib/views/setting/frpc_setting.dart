// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';

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
                  padding: const EdgeInsets.only(left: 30.0, right: 50.0),
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
                                _fcs.setSettingsFrpcDownloadMirror(value);
                                _dsCtr.frpcDownloadUseMirror.value = value;
                                _fcs.save();
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.pie_chart),
                                title: Text('选择镜像源'),
                              ),
                            ),
                            Obx(
                              () => DropdownButton<String>(
                                value: _dsCtr.selectedMirror.value,
                                onChanged: (value) {
                                  Logger.debug('Selected mirror id: $value');
                                  if (value != null) {
                                    _fcs.setSettingsFrpcDownloadMirrorId(value);
                                    _dsCtr.selectedMirror.value = value;
                                    _fcs.save();
                                  }
                                },
                                items: _dsCtr.downloadMirrors
                                    .map<DropdownMenuItem<String>>(
                                  (value) {
                                    return DropdownMenuItem<String>(
                                      value: value['id'],
                                      child: Text(value['name']),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
