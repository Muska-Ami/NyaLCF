import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';

class FrpcSetting {
  FrpcSetting({required this.context});

  final BuildContext context;
  final _fcs = FrpcConfigurationStorage();
  final FrpcSettingController _dsCtr = Get.find();

  final List<String> mirrorOptions = ['GitHub代理', 'LoCyan Mirror'];
  final RxString selectedMirror = 'GitHub代理'.obs;

  @override
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
                                leading: Icon(Icons.pie_chart),
                                title: Text('选择镜像源'),
                              ),
                            ),
                            Obx(
                              () => DropdownButton<String>(
                                value: selectedMirror.value,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    selectedMirror.value = newValue;
                                    if (mirrorOptions == 'GitHub代理') {
                                      onChanged:
                                          (value) async {
                                        _fcs.setSettingsGitHubMirror(value);
                                        _dsCtr.frpcDownloadUseMirror.value =
                                            value;
                                      };
                                    }else {
                                      /// TODO: LoCyanMirror下载选择
                                    }
                                  }
                                },
                                items: mirrorOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
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
