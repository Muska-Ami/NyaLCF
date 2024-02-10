import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nyalcf/storages/configurations/LauncherConfigurationStorage.dart';
import 'package:nyalcf/storages/injector.dart';
import 'package:nyalcf/utils/PathProvider.dart';
import 'package:nyalcf/main_tray.dart';
import 'package:nyalcf/main_window.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:get/get.dart';
import 'package:nyalcf/ui/views/auth/login.dart';
import 'package:nyalcf/ui/views/auth/register.dart';
import 'package:nyalcf/ui/views/auth/tokenmode.dart';
import 'package:nyalcf/ui/views/home.dart';
import 'package:nyalcf/ui/views/panel/console.dart';
import 'package:nyalcf/ui/views/panel/home.dart';
import 'package:nyalcf/ui/views/panel/proxies.dart';
import 'package:nyalcf/ui/views/setting/injector.dart';
import 'package:nyalcf/ui/views/tokenmode/panel.dart';
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

  doWhenWindowReady(MainWindow.doWhenWindowReady);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WindowListener, TrayListener {
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

  /// 组件销毁时操作
  @override
  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  onWindowClose() => MainWindow.onWindowClose();
  @override
  onTrayIconMouseDown() => MainTray.onTrayIconMouseDown();
  @override
  onTrayIconRightMouseDown() => MainTray.onTrayIconRightMouseDown();
  @override
  onTrayMenuItemClick(MenuItem menuItem) =>
      MainTray.onTrayMenuItemClick(menuItem);
}
