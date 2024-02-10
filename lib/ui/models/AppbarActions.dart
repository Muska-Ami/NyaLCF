import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/userController.dart';
import 'package:nyalcf/main_window.dart';

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
        onPressed: () => MainWindow.onWindowClose(),
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
}
