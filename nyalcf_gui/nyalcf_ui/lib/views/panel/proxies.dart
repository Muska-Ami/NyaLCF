// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/proxies_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class ProxiesPanelUI extends StatelessWidget {
  ProxiesPanelUI({super.key});

  final UserController _uCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    final pCtr = Get.put(ProxiesController(context: context));
    return NyaScaffold(
      name: '仪表板',
      appbarActions: AppbarActions(append: <Widget>[
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
      ], context: context),
      drawer: drawer(context),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5),
              child: const Column(
                children: <Widget>[
                  Text(
                    '隧道信息每隔 15 分钟更新，您也可以点击刷新立即更新。',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      pCtr.load(request: true);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('刷新'),
                        Icon(Icons.refresh),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed('/panel/proxies/configuration');
                    pCtr.load();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('管理高级配置文件'),
                      Icon(Icons.settings),
                    ],
                  ),
                ),
              ],
            ),
            Container(margin: const EdgeInsets.all(4)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(() => Wrap(
                      spacing: 8.0, // 水平间距
                      runSpacing: 4.0,
                      // ignore: invalid_use_of_protected_member
                      children: pCtr.proxiesWidgets.value,
                    ))
              ],
            )
          ],
        ),
      ),
      afterLayout: (RenderAfterLayout ral) async {
        if (ProxiesStorage.getAll().isEmpty) {
          pCtr.load(request: true);
        } else {
          pCtr.load();
        }
      },
    );
  }
}
