import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/consoleController.dart';
import 'package:nyalcf/controllers/frpcController.dart';
import 'package:nyalcf/controllers/userController.dart';
import 'package:nyalcf/ui/models/AccountDialog.dart';
import 'package:nyalcf/ui/models/AppbarActions.dart';
import 'package:nyalcf/ui/models/Drawer.dart';
import 'package:nyalcf/ui/models/FloatingActionButton.dart';
import 'package:nyalcf/ui/models/ProcessListDialog.dart';
import 'package:nyalcf/utils/frpc/ProcessManager.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key, required this.title});

  final UserController c = Get.find();
  final FrpcController f_c = Get.find();
  final ConsoleController c_c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    c_c.load();
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
      body: Center(
        child: ListView(
          children: <Widget>[
            Obx(
              () => Card(
                margin: EdgeInsets.all(20.0),
                color: Colors.grey.shade900,
                child: SizedBox(
                  width: Checkbox.width,
                  height: 340.0,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: ListView(
                      children: f_c.process_out,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    child: Text('查看进程列表'),
                    onPressed: () {
                      Get.dialog(ProcessListDialogX(context: context).build());
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '关闭所有进程',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      FrpcProcessManager().killAll();
                      c_c.widgets.refresh();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
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