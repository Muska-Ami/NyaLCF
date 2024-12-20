// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/other/sign_other.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/home_panel_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class PanelHome extends StatelessWidget {
  PanelHome({super.key});

  final UserController _uCtr = Get.find();
  final HomePanelController _hpCtr = Get.put(HomePanelController());

  @override
  Widget build(BuildContext context) {
    _uCtr.load();
    _hpCtr.load();

    return Scaffold(
      appBar: AppBar(
        title: const Text('$title - 仪表板'),

        //automaticallyImplyLeading: false,
        actions: AppbarActions(append: <Widget>[
          IconButton(
            onPressed: () {
              Get.dialog(accountDialog(context));
            },
            icon: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.network(
                    '${_uCtr.avatar}',
                    width: 35,
                  ),
                )),
          ),
        ], context: context)
            .actions(),
      ),
      drawer: drawer(context),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: <Widget>[
              Obx(() => Text(
                    '指挥官 ${_uCtr.user}，${_uCtr.welcomeText}喵！',
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
                                Obx(() => Text('用户名：${_uCtr.user}')),
                                Obx(() => Text('邮箱：${_uCtr.email}')),
                                Obx(() => Text(
                                    '限制速率：${_uCtr.inbound / 1024 * 8}Mbps/${_uCtr.outbound / 1024 * 8}Mbps')),
                                Obx(() => Text('剩余流量：${_uCtr.trafficRx} GiB'))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 15.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                loading.value = true;
                                final checkSignRes = await OtherSign.checkSign(
                                    _uCtr.user.value, _uCtr.token.value);
                                if (checkSignRes.status) {
                                  checkSignRes as SignResponse;
                                  Logger.debug(checkSignRes.signed);
                                  if (!checkSignRes.signed) {
                                    final doSignRes = await OtherSign().doSign(
                                        _uCtr.user.value, _uCtr.token.value);
                                    if (doSignRes.status) {
                                      doSignRes as SignDataResponse;
                                      Get.snackbar(
                                        '签到成功',
                                        doSignRes.firstSign
                                            ? '获得 ${doSignRes.getTraffic / 1024}GiB 流量，这是您的第一次签到呐~'
                                            : '获得 ${doSignRes.getTraffic / 1024}GiB 流量，您已签到 ${doSignRes.totalSignCount} 次，总计获得 ${doSignRes.totalGetTraffic / 1024} GiB 流量',
                                        snackPosition: SnackPosition.BOTTOM,
                                        animationDuration:
                                            const Duration(milliseconds: 300),
                                      );
                                    } else {
                                      if (doSignRes.message == "Signed") {
                                        Get.snackbar(
                                          '签到失败',
                                          '已签到，无法重复签到 QwQ',
                                          snackPosition: SnackPosition.BOTTOM,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                        );
                                      } else {
                                        Get.snackbar(
                                          '签到失败',
                                          '无法请求签到： ${doSignRes.message}',
                                          snackPosition: SnackPosition.BOTTOM,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                        );
                                      }
                                    }
                                  } else {
                                    Get.snackbar(
                                      '签到失败',
                                      '已签到，无法重复签到 Baka!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                    );
                                  }
                                } else {
                                  Get.snackbar(
                                    '签到失败',
                                    '无法检查当前签到状态： ${checkSignRes.message}',
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                  );
                                }
                                loading.value = false;
                              },
                              child: const Text('签到'),
                            ),
                          ),
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
                                  child: Column(
                                    children: <Widget>[
                                      const Text('Frp Token'),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: _uCtr.frpToken.value,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('已复制'),
                                            ),
                                          );
                                        },
                                        child: const Text('点击复制'),
                                      ),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: Column(
                                    children: <Widget>[
                                      const Text('Token'),
                                      ElevatedButton(
                                        onPressed: () async {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: _uCtr.token.value,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('已复制'),
                                          ));
                                        },
                                        child: const Text('点击复制'),
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
                                    data: '${_hpCtr.announcement}',
                                  )),
                            ),
                          ),
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
                                  data: '${_hpCtr.broadcast}',
                                )),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: floatingActionButton(),
    );
  }
}
