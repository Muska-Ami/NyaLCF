import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/consoleController.dart';
import 'package:nyalcf/controller/frpcController.dart';
import 'package:nyalcf/prefs/FrpcSettingPrefs.dart';
import 'package:nyalcf/prefs/TokenModePrefs.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:nyalcf/ui/model/ProcessListDialog.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

class TokenModePanel extends StatefulWidget {
  TokenModePanel({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _TokenModePanelState(title: title);
}

class _TokenModePanelState extends State {
  _TokenModePanelState({required this.title});

  final String title;

  final proxyController = TextEditingController();

  final FrpcController f_c = Get.find();
  final ConsoleController c_c = Get.put(ConsoleController());

  @override
  void dispose() {
    proxyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - TokenMode',
            style: const TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Card(
            color: Colors.blue.shade100,
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Text(
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
              Text('隧道ID'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 300,
                    margin: EdgeInsets.all(10.0),
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
                      final String? frp_token = await TokenModePrefs.getToken();
                      if (frp_token != null) if (proxyController.text != '') {
                        final frpcinfo = await FrpcSettingPrefs.getFrpcInfo();
                        if (frpcinfo.frpc_downloaded_versions.isNotEmpty) {
                          FrpcProcessManager().nwprcs(
                              frp_token: frp_token,
                              proxy_id: int.parse(proxyController.text));
                          Get.snackbar(
                            '启动命令已发出',
                            '请查看控制台确认是否启动成功',
                            snackPosition: SnackPosition.BOTTOM,
                            animationDuration: Duration(milliseconds: 300),
                          );
                        } else {
                          Get.snackbar(
                            '笨..笨蛋！',
                            '你还没有安装Frpc！请先到 设置->FRPC 安装Frpc才能启动喵！',
                            snackPosition: SnackPosition.BOTTOM,
                            animationDuration: Duration(milliseconds: 300),
                          );
                        }
                      } else
                        Get.snackbar(
                          '笨..笨蛋！',
                          '你还没有填写隧道ID，猫猫不知道要启动哪个隧道喵！',
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: Duration(milliseconds: 300),
                        );
                      else
                        Get.snackbar(
                          '发生错误',
                          '内部错误，请重新登录',
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: Duration(milliseconds: 300),
                        );
                    },
                    child: Text('启动'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 70.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                                ProcessListDialogX(context: context).build());
                          },
                          child: Text('查看进程列表'),
                        ),
                        Container(margin: EdgeInsets.only(left: 10.0)),
                        ElevatedButton(
                          onPressed: () {
                            FrpcProcessManager().killAll();
                          },
                          child: Text(
                            '关闭所有进程',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
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
              margin: EdgeInsets.all(20.0),
              color: Colors.grey.shade900,
              child: SizedBox(
                width: Checkbox.width,
                height: 200.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: ListView(
                    children: f_c.process_out,
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
