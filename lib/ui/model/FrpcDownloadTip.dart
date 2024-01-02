import 'package:flutter/material.dart';
import 'package:nyalcf/prefs/SettingPrefs.dart';

import 'FrpcDownloadDialog.dart';

class FrpcDownloadTip {
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
                                    return FrpcDownloadDialogX(context: context)
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
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('已安装版本列表：'),
                    Text((await SettingPrefs.getFrpcInfo())
                        .lists['frpc_downloaded_versions']
                        .toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
