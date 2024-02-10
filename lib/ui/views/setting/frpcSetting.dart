import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/frpcSettingController.dart';
import 'package:nyalcf/storages/configurations/FrpcConfigurationStorage.dart';

class FrpcSetting {
  FrpcSetting({required this.context});
  final context;
  final fcs = FrpcConfigurationStorage();
  final FrpcSettingController ds_c = Get.find();

  Widget widget() {
    ds_c.context = context;
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Obx(() => ds_c.frpc_download_tip.value),
          Container(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.trip_origin),
                    title: Text('下载源镜像设置'),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.auto_awesome),
                                  title: Text('启用下载镜像源'),
                                ),
                              ),
                              Switch(
                                value: ds_c.frpc_download_use_mirror.value,
                                onChanged: (value) async {
                                  fcs.setSettingsGitHubMirror(value);
                                  ds_c.frpc_download_use_mirror.value = value;
                                },
                              ),
                            ],
                          ),
                          /*/// TODO: 镜像选择
                        /// 纵向
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              /// 横向Container#1
                            ],
                          ),
                        ),*/
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}