import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/FrpcSettingController.dart';
import 'package:nyalcf/prefs/FrpcSettingPrefs.dart';

import 'FrpcDownloadDialog.dart';

class FrpcDownloadTip {

  static final FrpcSettingController ds_c = Get.find();

  static Container tip({required context}) => Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.warning),
                title: Text('尚未安装任何版本的 Frpc'),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('无法启动隧道了...呜呜...'),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return new FrpcDownloadDialogX(context: context)
                                        .build();
                                  });
                            },
                            child: Text('下载'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  static Future<Container> downloaded({required context}) async => Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('可用的 Frpc 版本已安装！素晴らしい！'),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('已安装版本列表：'),
                    Text((await FrpcSettingPrefs.getFrpcInfo())
                        .lists['frpc_downloaded_versions']
                        .toString()),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: reDownloadPress(context),
                      child: Text('重新下载'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  static dynamic reDownloadPress(context) {
    if (ds_c.frpc_download_end.value) return null;
    else return () async {
      showDialog(
          context: context,
          builder: (context) {
            return new FrpcDownloadDialogX(context: context)
                .build();
          });
    };
  }
}
