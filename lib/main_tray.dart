import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:nyalcf/main_window.dart';
import 'package:tray_manager/tray_manager.dart';

class MainTray {
  static final Menu menu = Menu(
    items: [
      MenuItem(
        key: 'show_window',
        label: '打开界面',
      ),
      MenuItem(
        key: 'hide_window',
        label: '隐藏界面',
      ),
      MenuItem(
        key: 'force_app_update',
        label: '强制更新App界面',
      ),
      MenuItem.separator(),
      MenuItem(
        key: 'exit_app',
        label: '退出',
      ),
    ],
  );

  /// 鼠标左键托盘图标
  static void onTrayIconMouseDown() {
    appWindow.restore();
  }

  /// 鼠标右键托盘图标
  static void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  // /// 保留备用
  // @override
  // void onTrayIconRightMouseUp() {}

  /// 托盘菜单点击事件
  static void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        appWindow.restore();
        break;
      case 'hide_window':
        appWindow.hide();
        break;
      case 'app_force_update':
        Get.forceAppUpdate();
        break;
      case 'exit_app':
        appWindow.restore();
        MainWindow.onWindowClose();
        break;
    }
  }
}
