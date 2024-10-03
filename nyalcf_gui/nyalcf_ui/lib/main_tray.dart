// Dart imports:
import 'dart:io';

// Package imports:
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

// Project imports:
import 'package:nyalcf_ui/main_window.dart';

class MainTray {
  // 初始化系统托盘
  static Future<SystemTray> initSystemTray() async {
    String path = Platform.isWindows ? 'icon.ico' : 'icon.png';

    final SystemTray systemTray = SystemTray();

    // Init icon
    await systemTray.initSystemTray(
      title: "Nya LoCyanFrp! 乐青映射启动器",
      iconPath: path,
    );

    // Init context menu
    await systemTray.setContextMenu(await _initMenu());
    systemTray.setToolTip("Nya~");

    // handle system tray event
    systemTray.registerSystemTrayEventHandler((eventName) {
      // debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        _onTrayIconMouseDown(systemTray);
      } else if (eventName == kSystemTrayEventRightClick) {
        _onTrayIconRightMouseDown(systemTray);
      }
    });
    return systemTray;
  }

  static Future<Menu> _initMenu() async {
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(
        onClicked: (item) async => _showWindow(),
        label: '打开界面',
      ),
      MenuItemLabel(
        onClicked: (item) async => appWindow.hide(),
        label: '隐藏界面',
      ),
      MenuItemLabel(
        onClicked: (item) async {
          _showWindow();
          appWindow.restore();
        },
        label: '还原窗口',
      ),
      MenuItemLabel(
        onClicked: (item) async => Get.forceAppUpdate,
        label: '强制更新 App 界面',
      ),
      MenuSeparator(),
      MenuItemLabel(
        onClicked: (item) async {
          _showWindow();
          MainWindow.onWindowClose();
        },
        label: '退出',
      ),
    ]);
    return menu;
  }

  /// 鼠标左键托盘图标
  static void _onTrayIconMouseDown(SystemTray systemTray) async {
    Platform.isWindows ? _showWindow() : systemTray.popUpContextMenu();
  }

  /// 鼠标右键托盘图标
  static void _onTrayIconRightMouseDown(SystemTray systemTray) async {
    Platform.isWindows ? systemTray.popUpContextMenu() : _showWindow();
  }

  static void _showWindow() {
    appWindow.show();
    windowManager.focus();
  }
}
