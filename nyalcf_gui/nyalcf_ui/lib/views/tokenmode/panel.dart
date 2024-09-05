import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_mode_prefs.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
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

  final ConsoleController _cCtr = Get.put(ConsoleController());

  @override
  void dispose() {
    // 改回原始最小大小
    const appMinSize = Size(600, 400);
    appWindow.minSize = appMinSize;
    proxyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 太小会溢出
    const appMinSize = Size(775, 400);
    const appSize = Size(775, 400);
    if (appWindow.size < appSize) appWindow.size = appSize;
    appWindow.minSize = appMinSize;
    final ScrollController scrollController = ScrollController();

    _cCtr.load();
    _cCtr.processOut.listen((data) {
      if (_cCtr.autoScroll.value && scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 200), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('$title - TokenMode',
            style: TextStyle(color: Colors.white)),
        actions: AppbarActions(context: context).actions(),
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
                    width: 200,
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
                            int proxyId;
                            try {
                              proxyId = int.parse(proxyController.text);
                            } on FormatException {
                              Get.snackbar(
                                '无效隧道ID',
                                '请填写隧道数字ID',
                                snackPosition: SnackPosition.BOTTOM,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                              );
                              return;
                            }
                            FrpcProcessManager().newProcess(
                              frpToken: frpToken,
                              proxyId: proxyId,
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
                            Get.dialog(processListDialog(context));
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
                            _cCtr.processOut.clear();
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
            ],
          ),
          Obx(
            () => Card(
              margin: const EdgeInsets.all(20.0),
              color: Colors.grey.shade900,
              child: SizedBox(
                width: Checkbox.width,
                height: MediaQuery.of(context).size.height - 270,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: AfterLayout(
                    callback: (RenderAfterLayout ral) => scrollController
                        .jumpTo(scrollController.position.maxScrollExtent),
                    child: ListView(
                      controller: scrollController,
                      children: _cCtr.processOut,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton(),
    );
  }
}
