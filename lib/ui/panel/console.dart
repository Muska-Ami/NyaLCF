import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dconsole.dart';
import 'package:nyalcf/controller/frpc.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/ui/model/AccountDialog.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/Drawer.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:nyalcf/ui/model/ProcessListDialog.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key, required this.title});

  // 用户控制器
  final UserController c = Get.find();
  // Frpc控制器
  final FrpcController f_c = Get.find();
  // 控制台控制器
  final ConsoleController c_c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    // 加载控制台数据
    c_c.load();
    return Scaffold(
        appBar: AppBar(
          // 标题
          title:
              Text('$title - 仪表板', style: const TextStyle(color: Colors.white)),

          // 是否自动应用Leading属性
          // automaticallyImplyLeading: false,
          // 操作栏
          actions: AppbarActionsX(append: <Widget>[
            // 账户对话框按钮
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
            children: [
              // 进程卡片
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
              // 进程按钮
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    // 进程列表对话框按钮
                    ElevatedButton(
                      onPressed: () {
                        Get.dialog(
                            ProcessListDialogX(context: context).build());
                      },
                      child: Text('查看进程列表'),
                    ),
                    // 关闭所有进程按钮
                    ElevatedButton(
                      onPressed: () {
                        FrpcProcessManager().killAll();
                      },
                      child: Text('关闭所有进程',
                          style: TextStyle(
                            color: Colors.white,
                          )),
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
        // 鼠标悬停按钮
        floatingActionButton: FloatingActionButtonX().button());
  }
}
