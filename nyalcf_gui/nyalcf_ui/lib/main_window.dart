// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:nyalcf_ui/main_tray.dart';

class MainWindow {
  static bool shouldCloseWindowShow = true;

  static SystemTray? _systemTray;

  /// 启动操作
  static void doWhenWindowReady() async {
    // 禁用系统窗口操作（主要适配MacOS）
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // 设置主窗体参数
    const minSize = Size(600, 400);
    const initialSize = Size(840, 500);
    appWindow.minSize = minSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Nya LoCyanFrp! - 乐青映射启动器';

    // 设置托盘菜单
    _systemTray = await MainTray.initSystemTray();

    // // Protocol Channel
    // void callback(deepLink) {
    //   Logger.debug(deepLink);
    // }

    // 显示主窗体
    appWindow.show();
  }

  /// 关闭确认
  static void onWindowClose() async {
    if (shouldCloseWindowShow) {
      shouldCloseWindowShow = false;
      bool isPreventClose = await windowManager.isPreventClose();
      if (isPreventClose) {
        appWindow.restore();
        await Get.dialog(AlertDialog(
          title: const Text('关闭 Nya LoCyanFrp!'),
          content: const Text(
              '确定要关闭 Nya LoCyanFrp! 吗，要是 Frpc 没关掉猫猫会生气把 Frpc 一脚踹翻的哦！'),
          actions: <Widget>[
            TextButton(
                child: const Text(
                  '取消',
                ),
                onPressed: () async {
                  Get.close(0);
                }),
            TextButton(
              child: const Text(
                '确定',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                try {
                  FrpcProcessManager().killAll();
                } catch (e, st) {
                  Logger.error('Failed to close all process: $e', t: st);
                }
                windowManager.destroy();
                _systemTray?.destroy();
                appWindow.close();
              },
            ),
          ],
        ));
        shouldCloseWindowShow = true;
      } else {
        shouldCloseWindowShow = true;
      }
    }
  }
}
