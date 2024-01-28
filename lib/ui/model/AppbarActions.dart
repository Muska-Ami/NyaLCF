import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/userController.dart';
import 'package:nyalcf/util/Logger.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

class AppbarActionsX {
  AppbarActionsX(
      {this.context = null,
      List<Widget> this.append = const <Widget>[],
      this.setting = true});

  final UserController c = Get.find();

  final BuildContext? context;
  bool setting;
  final List<Widget> append;

  List<Widget> _list() {
    return <Widget>[
      /// 移动窗口
      WindowTitleBarBox(
        child: MoveWindow(
          child: Transform.translate(
            offset: Offset(0, -5.0),
            child: IconButton(
              onPressed: () => {},
              icon: Icon(Icons.select_all),
              tooltip: '按住移动',
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              color: Colors.white,
            ),
          ),
        ),
      ),

      /// 最小化
      IconButton(
        onPressed: () => {appWindow.minimize()},
        icon: Icon(Icons.horizontal_rule),
        tooltip: '最小化',
        color: Colors.white,
      ),

      /// 关闭
      IconButton(
        onPressed: () => {closeAlertDialog()},
        icon: Icon(Icons.close),
        tooltip: '关闭',
        color: Colors.white,
      ),
    ];
  }

  List<Widget> actions() {
    List<Widget> l = <Widget>[];
    l.addAll(append);
    if (setting) {
      l.add(
        IconButton(
          onPressed: () => {Get.toNamed('/setting')},
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          tooltip: '设置',
          color: Colors.white,
        ),
      );
    }
    l.addAll(_list());
    return l;
  }

  closeAlertDialog() async {
    await Get.dialog(AlertDialog(
      title: Text('关闭NyaLCF'),
      content: Text('确定要关闭NyaLCF吗，要是Frpc没关掉猫猫会生气把Frpc一脚踹翻的哦！'),
      actions: <Widget>[
        TextButton(
            child: Text(
              '取消',
            ),
            onPressed: () async {
              Get.close(0);
            }),
        TextButton(
          child: Text(
            '确定',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            try {
              FrpcProcessManager().killAll();
            } catch (e) {
              Logger.error('Failed to close all process: ${e}');
            }
            appWindow.close();
          },
        ),
      ],
    ));
  }
}
