import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dconsole.dart';
import 'package:nyalcf/controller/dpanel.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/ui/model/AccountDialog.dart';
import 'package:nyalcf/ui/model/Drawer.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/AppbarActions.dart';

class PanelHome extends StatelessWidget {
  PanelHome({super.key, required this.title});

  final UserController c = Get.find();
  final DPanelController dp_c = Get.put(DPanelController());
  final ConsoleController c_c = Get.put(ConsoleController());
  final String title;

  @override
  Widget build(BuildContext context) {
    c.load();
    dp_c.load();

    return Scaffold(
        appBar: AppBar(
          title:
              Text('$title - 仪表板', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          //automaticallyImplyLeading: false,
          actions: AppbarActionsX(append: <Widget>[
            Obx(() => IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return AccountDialogX(context: context).build();
                      });
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.network(
                    '${c.avatar}',
                    width: 35,
                  ),
                ))),
          ], context: context)
              .actions(),
        ),
        drawer: DrawerX(context: context).drawer(),
        body: ListView(children: [
          Container(
              margin: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Obx(() => Text(
                          '指挥官 ${c.user}，${c.welcomeText}喵！',
                          style: TextStyle(fontSize: 15),
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Column(children: <Widget>[
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.info),
                                  title: Text('指挥官信息'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 15.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Obx(() => Text('用户名：${c.user}')),
                                      Obx(() => Text('邮箱：${c.email}')),
                                      Obx(() => Text(
                                          '限制速率：${c.inbound / 1024 * 8}Mbps/${c.outbound / 1024 * 8}Mbps')),
                                      Obx(() =>
                                          Text('剩余流量：${c.traffic / 1024}GiB'))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.looks),
                                  title: Text('会话详情'),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                          child: Column(children: <Widget>[
                                        Text('Frp Token'),
                                        ElevatedButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: c.frp_token.value));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('已复制'),
                                              ));
                                            },
                                            child: Text('点击复制'))
                                      ])),
                                      Card(
                                          child: Column(children: <Widget>[
                                        Text('Token'),
                                        ElevatedButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: c.token.value));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text('已复制'),
                                              ));
                                            },
                                            child: Text('点击复制'))
                                      ]))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.access_time),
                                  title: Text('通知'),
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            left: 15.0,
                                            right: 15.0,
                                            bottom: 15.0),
                                        child: Obx(() => MarkdownBody(
                                            selectable: true,
                                            onTapLink: (text, url, title) {
                                              if (url != null) {
                                                print(
                                                    'Launch url from Announcement: ${url}');
                                                launchUrl(Uri.parse(url));
                                              }
                                            },
                                            data:
                                                '${dp_c.announcement_common}'))))
                              ],
                            ),
                          )),
                        ])),
                        Expanded(
                            child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.announcement),
                                title: Text('公告'),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          bottom: 15.0),
                                      child: Obx(() => MarkdownBody(
                                          selectable: true,
                                          onTapLink: (text, url, title) {
                                            if (url != null) {
                                              print(
                                                  'Launch url from Announcement: ${url}');
                                              launchUrl(Uri.parse(url));
                                            }
                                          },
                                          data: '${dp_c.announcement}'))))
                            ],
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              )),
        ]),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
