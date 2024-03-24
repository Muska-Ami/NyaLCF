import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/proxies_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/ui/models/account_dialog.dart';
import 'package:nyalcf/ui/models/appbar_actions.dart';
import 'package:nyalcf/ui/models/drawer.dart';
import 'package:nyalcf/ui/models/floating_action_button.dart';

class PanelProxies extends StatelessWidget {
  PanelProxies({super.key, required this.title});

  final UserController uctr = Get.find();
  final String title;
  static bool loaded = false;

  @override
  Widget build(BuildContext context) {
    final pctr = Get.put(ProxiesController(context: context));
    if (!loaded) {
      pctr.load(uctr.user, uctr.token);
      loaded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title:
            Text('$title - 仪表板', style: const TextStyle(color: Colors.white)),

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
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5),
              child: const Column(
                children: <Widget>[
                  Text(
                    '隧道信息每隔15分钟更新，您也可以点击下方按钮立即更新。',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {pctr.load(uctr.user, uctr.token)},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text('刷新'), Icon(Icons.refresh)],
              ),
            ),
            Container(margin: const EdgeInsets.all(4)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(() => Wrap(
                      spacing: 8.0, // 水平间距
                      runSpacing: 4.0,
                      children: pctr.proxiesWidgets.value,
                    ))
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
