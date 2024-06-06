import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_core/utils/widget/after_layout.dart';
import 'package:nyalcf_core/controllers/proxies_controller.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class PanelProxies extends StatelessWidget {
  PanelProxies({super.key});

  final UserController _uCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    final pctr = Get.put(ProxiesController(context: context));
    return AfterLayout(
      callback: (RenderAfterLayout ral) {
        if (ProxiesStorage.get().isEmpty) {
          pctr.load(_uCtr.user, _uCtr.token, request: true);
        } else {
          pctr.load(_uCtr.user, _uCtr.token);
        }
      },
      child: Scaffold(
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
                      '${_uCtr.avatar}',
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
                onPressed: () =>
                    {pctr.load(_uCtr.user, _uCtr.token, request: true)},
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
                        // ignore: invalid_use_of_protected_member
                        children: pctr.proxiesWidgets.value,
                      ))
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button(),
      ),
    );
  }
}
