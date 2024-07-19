import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/frpc_controller.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_mode_prefs.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_ui.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';
import 'package:nyalcf_ui/models/process_list_dialog.dart';

class TokenModePanel extends StatefulWidget {
  const TokenModePanel({super.key});

  @override
  State<StatefulWidget> createState() => _TokenModePanelState();
}

class _TokenModePanelState extends State {
  final proxyController = TextEditingController();

  final FrpcController _fCtr = Get.find();
  final ConsoleController cctr = Get.put(ConsoleController());

  @override
  void dispose() {
    proxyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$title - TokenMode',
            style: TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Card(
            color: Colors.blue.shade100,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: const Text(
                '提示：您正在使用Frp Token模式，如需使用完整版本，请登录LoCyanFrp账户喵~',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('隧道ID'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 300,
                    margin: const EdgeInsets.all(10.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: '隧道ID',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                      controller: proxyController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final String? frpToken = await TokenModePrefs.getToken();
                      // 判断frp_token是否为空
                      if (frpToken != null) {
                        if (proxyController.text != '') {
                          final execPath = await FrpcPathProvider().frpcPath;
                          if (execPath != null) {
                            FrpcProcessManager().nwprcs(
                              frpToken: frpToken,
                              proxyId: int.parse(proxyController.text),
                              frpcPath: execPath,
                            );
                            Get.snackbar(
                              '启动命令已发出',
                              '请查看控制台确认是否启动成功',
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                            );
                            // 无环境变量未安装Frpc
                          } else {
                            Get.snackbar(
                              '笨..笨蛋！',
                              '你还没有安装Frpc！请先到 设置->FRPC 安装Frpc才能启动喵！',
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('启动'),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text('查看进程列表'),
                          onPressed: () async {
                            Get.dialog(
                                ProcessListDialogX(context: context).build());
                          },
                        ),
                        Container(margin: const EdgeInsets.only(left: 10.0)),
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
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: '清空日志',
                          onPressed: () async {
                            _fCtr.processOut.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(
            () => Card(
              margin: const EdgeInsets.all(20.0),
              color: Colors.grey.shade900,
              child: SizedBox(
                width: Checkbox.width,
                height: 200.0,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: _fCtr.processOut,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
