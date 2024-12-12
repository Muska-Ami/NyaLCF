// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/frpc_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/models/process_action_dialog.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class ConsolePanelUI extends StatelessWidget {
  ConsolePanelUI({super.key});

  final UserController _uCtr = Get.find();
  final ConsoleController _cCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    _cCtr.load();
    _cCtr.processOut.listen((data) {
      if (_cCtr.autoScroll.value && scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 200), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    });
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
                      height: MediaQuery.of(context).size.height - 160,
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
                        height: MediaQuery.of(context).size.height - 160,
                        child: Card(
                          color: Colors.grey.shade900,
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            child: Obx(
                              () => AfterLayout(
                                callback: (RenderAfterLayout ral) =>
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent),
                                child: ListView(
                                  controller: scrollController,
                                  children: _cCtr.processOut,
                                ),
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
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          '关闭所有进程',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          FrpcProcessManager().killAll();
                          _cCtr.widgets.refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: '清空日志',
                        onPressed: () async {
                          _cCtr.processOut.clear();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        tooltip: '全屏',
                        onPressed: () async {
                          Get.toNamed('/panel/console/full');
                        },
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: _cCtr.autoScroll.value,
                              onChanged: (value) =>
                                  _cCtr.autoScroll.value = value ?? false,
                            ),
                          ),
                          const Text('自动滚动'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static buildProcessListWidget() {
    var processList = FrpcController.processList;
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
              title: Text('隧道 ${element.proxyId}'),
              subtitle: Text('进程 PID: ${element.process.pid}'),
            ),
            onTap: () async {
              Get.dialog(processActionDialog(element));
            },
          ),
        ),
      );
    }

    ConsoleController.processListWidget.value = widgets;
  }
}
