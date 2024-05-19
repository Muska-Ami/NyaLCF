import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/main_window.dart';

class AppbarActionsX {
  AppbarActionsX(
      {this.context, this.append = const <Widget>[], this.setting = true});

  final UserController uctr = Get.find();

  final BuildContext? context;
  bool setting;
  final List<Widget> append;

  List<Widget> get _afterList => <Widget>[
        /// 移动窗口
        WindowTitleBarBox(
          child: MoveWindow(
            child: Transform.translate(
              offset: const Offset(0, -5.0),
              child: IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.select_all),
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
          icon: const Icon(Icons.horizontal_rule),
          tooltip: '最小化',
          color: Colors.white,
        ),

        /// 关闭
        IconButton(
          onPressed: () => MainWindow.onWindowClose(),
          icon: const Icon(Icons.close),
          tooltip: '关闭',
          color: Colors.white,
        ),
      ];

  List<Widget> get _beforeList => <Widget>[
        SizedBox(
          width: 16,
          height: 16,
          child: Obx(
            () =>
                loading.value ? const CircularProgressIndicator() : Container(),
          ),
        ),
      ];

  List<Widget> actions() {
    // Actions列表
    List<Widget> l = <Widget>[];
    l.addAll(_beforeList);
    l.addAll(append);
    if (setting) {
      l.add(
        IconButton(
          onPressed: () => Get.toNamed('/setting'),
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          tooltip: '设置',
          color: Colors.white,
        ),
      );
    }
    l.addAll(_afterList);
    return l;
  }
}
