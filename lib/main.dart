import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/storages/injector.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/path_provider.dart';
import 'package:nyalcf_core/utils/universe.dart';
import 'package:nyalcf_core/utils/task_scheduler.dart';
import 'package:nyalcf_core/utils/deep_link_register.dart';
import 'package:nyalcf_core/utils/deep_link_executor.dart';
import 'package:nyalcf_ui/main_tray.dart';
import 'package:nyalcf_ui/main_window.dart';
import 'package:nyalcf_ui/views/auth/login.dart';
import 'package:nyalcf_ui/views/auth/register.dart';
import 'package:nyalcf_ui/views/auth/tokenmode.dart';
import 'package:nyalcf_ui/views/home.dart';
import 'package:nyalcf_ui/views/panel/console.dart';
import 'package:nyalcf_ui/views/panel/console_full.dart';
import 'package:nyalcf_ui/views/panel/home.dart';
import 'package:nyalcf_ui/views/panel/proxies.dart';
import 'package:nyalcf_ui/views/setting/injector.dart';
import 'package:nyalcf_ui/views/tokenmode/panel.dart';

final _appLinks = AppLinks();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await Universe.loadUniverse();

  /// 初始化配置文件等
  await PathProvider.loadSyncPath();
  await StoragesInjector.init();
  await Logger.init();

  /// 注册并监听深度链接
  if (Platform.isWindows) DeepLinkRegister.registerWindows('locyanfrp');
  _appLinks.uriLinkStream.listen((uri) {
    Logger.debug('Received uri scheme: $uri');
    DeepLinkExecutor(uri: uri.toString()).execute();
  });

  /// 启动定时任务
  TaskScheduler.start();

  runApp(const App());

  doWhenWindowReady(MainWindow.doWhenWindowReady);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener, TrayListener {
  /// 根组件
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = LauncherConfigurationStorage().getTheme();

    return GetMaterialApp(
      logWriterCallback: Logger.getxLogWriter,
      title: 'Nya LoCyanFrp!',
      routes: {
        '/': (context) => Home(),
        '/auth/login': (context) => const Login(),
        '/auth/register': (context) => const Register(),
        '/token_mode/login': (context) => const TokenModeAuth(),
        '/token_mode/panel': (context) => const TokenModePanel(),
        '/panel/home': (context) => PanelHome(),
        '/panel/proxies': (context) => PanelProxies(),
        '/panel/console': (context) => PanelConsole(),
        '/panel/console/full': (context) => PanelConsoleFull(),
        '/setting': (context) => const SettingInjector(),
      },
      theme: themeData,
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
