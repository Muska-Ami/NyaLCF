// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/network/client/api/sign.dart' as api_sign;
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/home_panel_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';

class HomePanelUI extends StatelessWidget {
  HomePanelUI({super.key});

  final UserController _uCtr = Get.find();
  final HomePanelController _hpCtr = Get.put(HomePanelController());

  @override
  Widget build(BuildContext context) {
    _uCtr.load();
    _hpCtr.load();

    return NyaScaffold(
      name: '仪表板',
      appbarActions: AppbarActions(
        append: <Widget>[
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
        ],
        context: context,
      ),
      drawer: drawer(context),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Column(
            children: <Widget>[
              Obx(() => Text(
                    '指挥官 ${_uCtr.username}，${_uCtr.welcomeText}喵！',
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
                                Obx(() => Text('用户名：${_uCtr.username}')),
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

                                final UserInfoModel userInfo =
                                    await UserInfoPrefs.getInfo();
                                final ApiClient api = ApiClient(
                                    accessToken:
                                        await TokenInfoPrefs.getAccessToken());

                                final rs = await api
                                    .get(api_sign.GetSign(userId: userInfo.id));
                                if (rs == null) {
                                  Get.snackbar(
                                    '签到失败',
                                    '请求失败惹 QwQ',
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                  );
                                  return;
                                }
                                if (rs.statusCode == 200) {
                                  !rs.data['data']['status']
                                      ? () async {
                                          final rsx = await api.get(
                                              api_sign.PostSign(
                                                  userId: userInfo.id));
                                          if (rsx == null) {
                                            Get.snackbar(
                                              '签到失败',
                                              '请求失败惹 QwQ',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                            );
                                            return;
                                          }
                                          rsx.data['data']['status']
                                              ? () async {
                                                  Get.snackbar(
                                                    '签到成功',
                                                    rsx.data['data']
                                                            ['first_sign']
                                                        ? '获得 ${rsx.data['data']['get_traffic'] / 1024}GiB 流量，这是您的第一次签到呐~'
                                                        : '获得 ${rsx.data['data']['get_traffic'] / 1024}GiB 流量，您已签到 ${rsx.data['data']['sign_count']} 次，总计获得 ${rsx.data['data']['total_get_traffic'] / 1024} GiB 流量',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    animationDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                  );
                                                }
                                              : () async {
                                                  rsx.data['message'] ==
                                                          "Signed"
                                                      ? Get.snackbar(
                                                          '签到失败',
                                                          '已签到，无法重复签到 QwQ',
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          animationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                        )
                                                      : Get.snackbar(
                                                          '签到失败',
                                                          '无法请求签到： ${rsx.data['message']}',
                                                          snackPosition:
                                                              SnackPosition
                                                                  .BOTTOM,
                                                          animationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                        );
                                                };
                                        }
                                      : Get.snackbar(
                                          '签到失败',
                                          '已签到，无法重复签到 Baka!',
                                          snackPosition: SnackPosition.BOTTOM,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                        );
                                } else {
                                  Get.snackbar(
                                    '签到失败',
                                    '后端返回： ${rs.data['message']}',
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
    );
  }
}
