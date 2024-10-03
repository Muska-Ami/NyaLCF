// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:app_links/app_links.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/injector.dart';
import 'package:nyalcf_core/utils/deep_link_register.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_mode_prefs.dart';
import 'package:nyalcf_core_extend/utils/deep_link_executor.dart';
import 'package:nyalcf_core_extend/utils/path_provider.dart';
import 'package:nyalcf_core_extend/utils/task_scheduler.dart';
import 'package:nyalcf_core_extend/utils/theme_control.dart';
import 'package:nyalcf_core_extend/utils/universe.dart';
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/main_window.dart';
import 'package:nyalcf_ui/views/auth/login.dart';
import 'package:nyalcf_ui/views/auth/register.dart';
import 'package:nyalcf_ui/views/auth/tokenmode.dart';
import 'package:nyalcf_ui/views/home.dart';
import 'package:nyalcf_ui/views/license.dart';
import 'package:nyalcf_ui/views/panel/console.dart';
import 'package:nyalcf_ui/views/panel/console_full.dart';
import 'package:nyalcf_ui/views/panel/home.dart';
import 'package:nyalcf_ui/views/panel/proxies.dart';
import 'package:nyalcf_ui/views/panel/proxies_configuration.dart';
import 'package:nyalcf_ui/views/setting/injector.dart';
import 'package:nyalcf_ui/views/tokenmode/panel.dart';
import 'package:window_manager/window_manager.dart';

final _appLinks = AppLinks();
bool _appInit = false;

void main() async {
  /// 确保前置内容完成初始化
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  /// 读取信息
  await Universe.loadUniverse();

  /// 设置 HTTP 请求附加信息
  setAppendInfo(
      'v${Universe.appVersion}(+${Universe.appBuildNumber}) an=${Universe.appName}');

  /// 初始化配置文件等
  await PathProvider.loadSyncPath();

  /// 初始化数据存储
  await StoragesInjector.init();

  /// 初始化 Logger
  await Logger.init();

  /// 自动旧版迁移数据
  final appSupportParentPath = Directory(appSupportPath!).parent.parent.path;
  if (Directory('$appSupportParentPath/moe.xmcn.nyanana').existsSync()) {
    if (!Directory('$appSupportParentPath/moe.muska.ami').existsSync()) {
      Directory('$appSupportParentPath/moe.muska.ami').createSync();
    }
    try {
      await moveDirectory(
        Directory('$appSupportParentPath/moe.xmcn.nyanana/nyanana'),
        Directory('$appSupportParentPath/moe.muska.ami/nyanana'),
      );
    } catch (e, st) {
      Logger.error('Could not automatic move launcher data to new folder!');
      Logger.error(e, t: st);
    }
  }

  Logger.debug('Append info has been set: $appendInfo');

  /// 注册并监听深度链接
  if (!(ENV_GUI_DISABLE_DEEPLINK ?? false)) {
    if (Platform.isWindows) DeepLinkRegister.registerWindows('locyanfrp');
    _appLinks.uriLinkStream.listen((uri) async {
      Logger.debug('Received uri scheme: $uri');
      final res = await DeepLinkExecutor(uri: uri.toString()).execute();

      Logger.debug(res);
      if (res[0]) {
        Logger.debug('Started as token-only mode as deeplink executed success');
        await TokenModePrefs.setToken(res[1]);
        await Future.doWhile(() async {
          if (_appInit) {
            Get.toNamed('/token_mode/panel');
            return false; // 结束循环
          }
          Logger.debug('Waiting for app init...');
          await Future.delayed(const Duration(milliseconds: 1000)); // 延迟检查
          return true; // 继续循环
        });
      } else {
        Logger.debug('Skip for enter token-only mode');
      }
    });
  }

  /// 启动定时任务
  TaskScheduler.start();

  /// 运行 App
  runApp(const App());

  /// 当窗口初始化完毕执行
  doWhenWindowReady(MainWindow.doWhenWindowReady);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener {
  /// 根组件
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeControl().getTheme();

    final app = GetMaterialApp(
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
        '/panel/proxies/configuration': (context) =>
            PanelProxiesConfiguration(),
        '/panel/console': (context) => PanelConsole(),
        '/panel/console/full': (context) => PanelConsoleFull(),
        '/setting': (context) => const SettingInjector(),
        '/license': (context) => const License(),
      },
      theme: themeData,
    );
    _appInit = true;
    return app;
  }

  /// 组件初始化时操作
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
    _init();
  }

  /// 异步初始化内容
  Future<void> _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  /// 组件销毁时操作
  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // 窗口和托盘图标的事件处理
  @override
  onWindowClose() => MainWindow.onWindowClose();
}
