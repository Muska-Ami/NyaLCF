import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/console_controller.dart';
import 'package:nyalcf/controllers/panel_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/main.dart';
import 'package:nyalcf/ui/models/account_dialog.dart';
import 'package:nyalcf/ui/models/appbar_actions.dart';
import 'package:nyalcf/ui/models/drawer.dart';
import 'package:nyalcf/ui/models/floating_action_button.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class PanelHome extends StatelessWidget {
  PanelHome({super.key});

  final UserController uctr = Get.find();
  final DPanelController dpctr = Get.put(DPanelController());
  final ConsoleController cctr = Get.put(ConsoleController());

  @override
  Widget build(BuildContext context) {
    uctr.load();
    dpctr.load();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('$title - 仪表板', style: TextStyle(color: Colors.white)),

        //automaticallyImplyLeading: false,
        actions: AppbarActionsX(append: <Widget>[
          IconButton(
            onPressed: () {
              Get.dialog(AccountDialogX(context: context).build());
            },
            icon: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.network(
                    '${uctr.avatar}',
                    width: 35,
                  ),
                )),
          ),
        ], context: context)
            .actions(),
      ),
      drawer: DrawerX(context: context).drawer(),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: <Widget>[
              Obx(() => Text(
                    '指挥官 ${uctr.user}，${uctr.welcomeText}喵！',
                    style: const TextStyle(fontSize: 15),
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
                          const ListTile(
                            leading: Icon(Icons.info),
                            title: Text('指挥官信息'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Obx(() => Text('用户名：${uctr.user}')),
                                Obx(() => Text('邮箱：${uctr.email}')),
                                Obx(() => Text(
                                    '限制速率：${uctr.inbound / 1024 * 8}Mbps/${uctr.outbound / 1024 * 8}Mbps')),
                                Obx(() =>
                                    Text('剩余流量：${uctr.traffic / 1024}GiB'))
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
                          const ListTile(
                            leading: Icon(Icons.looks),
                            title: Text('会话详情'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Card(
                                    child: Column(children: <Widget>[
                                  const Text('Frp Token'),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: uctr.frpToken.value,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('已复制'),
                                        ));
                                      },
                                      child: const Text('点击复制'))
                                ])),
                                Card(
                                    child: Column(children: <Widget>[
                                  const Text('Token'),
                                  ElevatedButton(
                                      onPressed: () async {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: uctr.token.value,
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text('已复制'),
                                        ));
                                      },
                                      child: const Text('点击复制'))
                                ]))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('通知'),
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 15.0),
                                  child: Obx(() => MarkdownBody(
                                      selectable: true,
                                      onTapLink: (text, url, title) {
                                        if (url != null) {
                                          Logger.debug(
                                              'Launch url from Announcement: $url');
                                          launchUrl(Uri.parse(url));
                                        }
                                      },
                                      data: '${dpctr.announcementCommon}'))))
                        ],
                      ),
                    ),
                  ])),
                  Expanded(
                      child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.announcement),
                          title: Text('公告'),
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 15.0),
                                child: Obx(() => MarkdownBody(
                                    selectable: true,
                                    onTapLink: (text, url, title) {
                                      if (url != null) {
                                        Logger.debug(
                                            'Launch url from Announcement: $url');
                                        launchUrl(Uri.parse(url));
                                      }
                                    },
                                    data: '${dpctr.announcement}'))))
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
