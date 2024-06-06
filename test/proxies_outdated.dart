import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_core/controllers/proxies_controller.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class PanelProxies extends StatelessWidget {
  PanelProxies({super.key, required this.title});

  final UserController _uCtr = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    final pctr = Get.put(ProxiesController(context: context));

    pctr.build(_uCtr.user, _uCtr.token);

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
        margin: const EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => {pctr.load(_uCtr.user, _uCtr.token)},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text('刷新'), Icon(Icons.refresh)],
              ),
            ),
            Obx(
              () => Column(
                children: <Widget>[
                  DataTable(
                    columnSpacing: 10.0,
                    columns: const <DataColumn>[
                      DataColumn(label: Flexible(child: Text('名称'))),
                      DataColumn(label: Flexible(child: Text('ID'))),
                      DataColumn(label: Flexible(child: Text('节点'))),
                      DataColumn(label: Flexible(child: Text('协议'))),
                      DataColumn(label: Flexible(child: Text('本地IP'))),
                      DataColumn(label: Flexible(child: Text('端口'))),
                      DataColumn(label: Flexible(child: Text('操作')))
                    ],
                    rows: const [],
                    //rows: pctr.proxiesListWidgets.value,
                  ),
                ],
              ),
            ),
            // ElevatedButton(onPressed: () => Get.toNamed('/panel/proxies_new'), child: Text(''))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
