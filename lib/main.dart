import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/io/launcherSettingStorage.dart';
import 'package:nyalcf/model/LauncherSettingModel.dart';
import 'package:nyalcf/prefs/LauncherSettingPrefs.dart';
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
import 'package:nyalcf/util/Logger.dart';
import 'package:nyalcf/util/ThemeControl.dart';
import 'package:nyalcf/util/Updater.dart';

LauncherSettingModel? _settings = null;

void main() async {

  await Logger.clear();

  /// 初始化配置文件
  LauncherSettingStorage.init();
  FrpcManagerStorage.init();
  _settings = await LauncherSettingStorage.read();

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
      Platform.isWindows
          ? 'asset/icon/icon.ico'
          : 'asset/icon/icon.png',
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

class _AppState extends State<App> with TrayListener {
  final title = 'Nya LoCyanFrp!';
  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LauncherSettingPrefs.setInfo(_settings ??
        LauncherSettingModel(
          theme_auto: true,
          theme_dark: false,
          theme_light_seed_enable: false,
          theme_light_seed: '66ccff',
        ));

    ThemeData _theme_data;

    final bool isDarkMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;

    Logger.info('System dark mode: ${isDarkMode}');

    /// 判定是否需要切换暗色主题
    if (((_settings?.theme_auto ?? true) && isDarkMode) ||
        (_settings?.theme_dark ?? false)) {
      _theme_data = ThemeControl.dark;
    } else {
      _theme_data = ThemeControl.light;
    }

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

  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  @override
  void onTrayIconMouseDown() {
    appWindow.restore();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {

  }

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
