import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/console_controller.dart';
import 'package:nyalcf/controllers/frpc_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/ui/models/account_dialog.dart';
import 'package:nyalcf/ui/models/appbar_actions.dart';
import 'package:nyalcf/ui/models/drawer.dart';
import 'package:nyalcf/ui/models/floating_action_button.dart';
import 'package:nyalcf/ui/models/process_list_dialog.dart';
import 'package:nyalcf/utils/frpc/process_manager.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key, required this.title});

  final UserController uctr = Get.find();
  final FrpcController fctr = Get.find();
  final ConsoleController cctr = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    cctr.load();
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
      body: Center(
        child: ListView(
          children: <Widget>[
            Obx(
              () => Card(
                margin: const EdgeInsets.all(20.0),
                color: Colors.grey.shade900,
                child: SizedBox(
                  width: Checkbox.width,
                  height: 340.0,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: fctr.processOut,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('查看进程列表'),
                    onPressed: () async {
                      Get.dialog(ProcessListDialogX(context: context).build());
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text(
                      '关闭所有进程',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      FrpcProcessManager().killAll();
                      cctr.widgets.refresh();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: '清空日志',
                    onPressed: () async {
                      fctr.processOut.clear();
                    },
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
