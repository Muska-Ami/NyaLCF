import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nyalcf/storages/configurations/LauncherConfigurationStorage.dart';
import 'package:nyalcf/storages/injector.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/utils/PathProvider.dart';
import 'package:nyalcf/utils/frpc/ProcessManager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyalcf/protocol_activation.dart';
import 'package:nyalcf/ui/auth/login.dart';
import 'package:nyalcf/ui/auth/register.dart';
import 'package:nyalcf/ui/auth/tokenmode.dart';
import 'package:nyalcf/ui/home.dart';
import 'package:nyalcf/ui/panel/console.dart';
import 'package:nyalcf/ui/panel/home.dart';
import 'package:nyalcf/ui/panel/proxies.dart';
import 'package:nyalcf/ui/setting/injector.dart';
import 'package:nyalcf/ui/tokenmode/panel.dart';
import 'package:nyalcf/utils/Logger.dart';
import 'package:nyalcf/utils/Updater.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  /// 初始化配置文件
  await PathProvider.loadSyncPath();
  await StoragesInjector.init();

  //await Logger.clear();

  /// 启动更新
  Updater.startUp();

  runApp(const App());

  doWhenWindowReady(() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    const initialSize = Size(800, 500);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Nya LoCyanFrp! - LCF启动器';
    appWindow.show();
    await trayManager.setToolTip('Nya~');
    await trayManager.setIcon(
      Platform.isWindows ? 'asset/icon/icon.ico' : 'asset/icon/icon.png',
    );
    Menu menu = Menu(
      items: [
        MenuItem(
          key: 'show_window',
          label: '打开界面',
        ),
        MenuItem(
          key: 'hide_window',
          label: '隐藏界面',
        ),
        MenuItem.separator(),
        MenuItem(
          key: 'exit_app',
          label: '退出',
        ),
      ],
    );
    trayManager.setContextMenu(menu);

    await ProtocolActivation.registerProtocolActivation(callback);
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with TrayListener, WindowListener {
  final title = 'Nya LoCyanFrp!';

  /// 根组件
  @override
  Widget build(BuildContext context) {
    ThemeData _theme_data = LauncherConfigurationStorage().getTheme();

    return GetMaterialApp(
      logWriterCallback: Logger.getxLogWriter,
      title: 'Nya LoCyanFrp!',
      routes: {
        '/': (context) => Home(title: title),
        '/auth/login': (context) => Login(title: title),
        '/auth/register': (context) => Register(title: title),
        '/token_mode/login': (context) => TokenModeAuth(title: title),
        '/token_mode/panel': (context) => TokenModePanel(title: title),
        '/panel/home': (context) => PanelHome(title: title),
        '/panel/proxies': (context) => PanelProxies(title: title),
        '/panel/console': (context) => PanelConsole(title: title),
        '/setting': (context) => SettingInjector(title: title),
      },
      theme: _theme_data,
    );
  }

  /// 组件初始化时操作
  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      appWindow.restore();
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
              windowManager.destroy();
            },
          ),
        ],
      ));
    }
  }

  /// 组件销毁时操作
  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  /// 鼠标左件托盘图标
  @override
  void onTrayIconMouseDown() {
    appWindow.restore();
  }

  /// 鼠标右键托盘图标
  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  // /// 保留备用
  // @override
  // void onTrayIconRightMouseUp() {}

  /// 托盘菜单点击事件
  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_window':
        appWindow.restore();
        break;
      case 'hide_window':
        appWindow.hide();
        break;
      case 'exit_app':
        appWindow.restore();
        AppbarActionsX().closeAlertDialog();
        break;
    }
  }
}

void callback(deepLink) {
  Logger.debug(deepLink);
}
