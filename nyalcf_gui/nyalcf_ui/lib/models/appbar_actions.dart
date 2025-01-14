// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/main_window.dart';
import 'package:nyalcf_ui/widgets/nya_loading_circle.dart';

class AppbarActions {
  AppbarActions({
    this.context,
    this.append = const <Widget>[],
    this.setting = true,
  });

  final BuildContext? context;
  bool setting;
  final List<Widget> append;

  List<Widget> get _afterList => <Widget>[
        /// 移动窗口
        MoveWindow(
          child: IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.select_all),
            tooltip: '按住移动',
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        ),

        /// 最小化
        IconButton(
          onPressed: () => {appWindow.minimize()},
          icon: const Icon(Icons.horizontal_rule),
          tooltip: '最小化',
        ),

        /// 关闭
        IconButton(
          onPressed: () => MainWindow.onWindowClose(),
          icon: const Icon(Icons.close),
          tooltip: '关闭',
        ),
      ];

  List<Widget> get _beforeList => <Widget>[
        Obx(
          () => loading.value
              ? const NyaLoadingCircle(height: 16.0, width: 16.0)
              : Container(),
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
          ),
          tooltip: '设置',
        ),
      );
    }
    l.addAll(_afterList);
    return l;
  }
}
