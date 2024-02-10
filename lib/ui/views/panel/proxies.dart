import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/proxiesController.dart';
import 'package:nyalcf/controllers/userController.dart';
import 'package:nyalcf/ui/models/AccountDialog.dart';
import 'package:nyalcf/ui/models/AppbarActions.dart';
import 'package:nyalcf/ui/models/Drawer.dart';
import 'package:nyalcf/ui/models/FloatingActionButton.dart';

class PanelProxies extends StatelessWidget {
  PanelProxies({required this.title});

  final UserController c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    final p_c = Get.put(ProxiesController(context: context));

    p_c.load(c.user, c.token);

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
                    '${c.avatar}',
                    width: 35,
                  ),
                )),
          ),
        ], context: context)
            .actions(),
      ),
      drawer: DrawerX(context: context).drawer(),
      body: Container(
        margin: EdgeInsets.all(40.0),
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => {p_c.reload(c.user, c.token)},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text('刷新'), Icon(Icons.refresh)],
              ),
            ),
            Obx(
              () => Column(
                children: <Widget>[
                  DataTable(
                    columnSpacing: 10.0,
                    columns: <DataColumn>[
                      DataColumn(label: Flexible(child: Text('名称'))),
                      DataColumn(label: Flexible(child: Text('ID'))),
                      DataColumn(label: Flexible(child: Text('节点'))),
                      DataColumn(label: Flexible(child: Text('协议'))),
                      DataColumn(label: Flexible(child: Text('本地IP'))),
                      DataColumn(label: Flexible(child: Text('端口'))),
                      DataColumn(label: Flexible(child: Text('操作')))
                    ],
                    rows: p_c.proxiesListWidgets.value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
