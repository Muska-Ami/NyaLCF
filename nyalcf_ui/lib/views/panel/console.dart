import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/console_controller.dart';
import 'package:nyalcf_core/controllers/frpc_controller.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';
import 'package:nyalcf_ui/models/process_action_dialog.dart';
import 'package:nyalcf_core/utils/frpc/process_manager.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key});

  final UserController _uCtr = Get.find();
  final FrpcController _fCtr = Get.find();
  final ConsoleController cctr = Get.find();

  @override
  Widget build(BuildContext context) {
    cctr.load();
    return Scaffold(
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180.0,
                      height: MediaQuery.of(context).size.height-160,
                      child: Card(
                        child: Obx(
                          () => Column(
                            children: <Widget>[
                              ListTile(
                                title: const Text('进程列表'),
                                subtitle: Text(
                                  '点击操作进程',
                                  style: TextStyle(
                                    color: Get.theme.disabledColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children:
                                      ConsoleController.processListWidget.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height-160,
                        child: Card(
                          color: Colors.grey.shade900,
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Obx(
                              () => ListView(
                                children: _fCtr.processOut,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: <Widget>[
                      // ElevatedButton(
                      //   child: const Text('查看进程列表'),
                      //   onPressed: () async {
                      //     Get.dialog(
                      //         ProcessListDialogX(context: context).build());
                      //   },
                      // ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.red),
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
                          _fCtr.processOut.clear();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        tooltip: '全屏',
                        onPressed: () async {
                          Get.toNamed('/panel/console/full');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }

  static buildProcessListWidget() {
    var processList = ConsoleController.processList;
    var widgets = <Widget>[];

    for (var element in processList) {
      widgets.add(
        Card(
          color: Get.theme.highlightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide.none,
          ),
          elevation: 0,
          child: InkWell(
            child: ListTile(
              title: Text('隧道 ${element['proxy_id']}'),
              subtitle: Text('进程PID: ${element['process'].pid}'),
            ),
            onTap: () async {
              Get.dialog(ProcessActionDialogX(process: element).build());
            },
          ),
        ),
      );
    }

    ConsoleController.processListWidget.value = widgets;
  }
}
