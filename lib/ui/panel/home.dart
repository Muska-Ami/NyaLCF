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
import 'package:nyalcf/util/Logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/AppbarActions.dart';

// 定义主页小部件
class PanelHome extends StatelessWidget {
  // 构造函数，用于使用标题初始化小部件
  PanelHome({super.key, required this.title});

  // 初始化控制器
  final UserController c = Get.find();
  final DPanelController dp_c = Get.put(DPanelController());
  final ConsoleController c_c = Get.put(ConsoleController());
  final String title;

  @override
  Widget build(BuildContext context) {
    // 加载用户和面板数据
    c.load();
    dp_c.load();

    // 构建包含应用栏、抽屉、主体和浮动操作按钮的主脚手架
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - 仪表板', style: const TextStyle(color: Colors.white)),
        // 定义应用栏操作
        actions: AppbarActionsX(append: <Widget>[
          // 在应用栏中显示用户头像，调用Cravatar（官方为Cravatar-QQ-Gravatar）
          IconButton(
            onPressed: () {
              Get.dialog(AccountDialogX(context: context).build());
            },
            icon: Obx(() => ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: Image.network(
                '${c.avatar}',
                width: 35,
              ),
            )),
          ),
        ], context: context).actions(),
      ),
      drawer: DrawerX(context: context).drawer(), // 显示会话抽屉
      body: ListView(children: [
        // 主面板主页的主要内容
        Container(
          margin: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              children: <Widget>[
                // 显示用户信息
                Obx(() => Text(
                  '指挥官 ${c.user}，${c.welcomeText}喵！',
                  style: TextStyle(fontSize: 15),
                )),
                // 在卡片中显示用户详细信息
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          // 用于用户信息的卡片
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          // 用于会话详细信息的卡片
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                          child: Column(children: <Widget>[
                                            Text('Frp Token'),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                      text: c.frp_token.value,
                                                    ),
                                                  );
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
                                                onPressed: () async {
                                                  Clipboard.setData(
                                                    ClipboardData(
                                                      text: c.token.value,
                                                    ),
                                                  );
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
                          // 用于通知的卡片
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
                                                  Logger.debug(
                                                      '从通知中打开的URL: ${url}');
                                                  launchUrl(Uri.parse(url));
                                                }
                                              },
                                              data:
                                              '${dp_c.announcement_common}'))))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 用于公告的卡片
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
                                        left: 15.0, right: 15.0, bottom: 15.0),
                                    child: Obx(() => MarkdownBody(
                                        selectable: true,
                                        onTapLink: (text, url, title) {
                                          if (url != null) {
                                            Logger.debug(
                                                '从公告中打开的URL: ${url}');
                                            launchUrl(Uri.parse(url));
                                          }
                                        },
                                        data: '${dp_c.announcement}'))))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
