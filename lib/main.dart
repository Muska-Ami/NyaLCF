import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/io/settingStorage.dart';
import 'package:nyalcf/model/Setting.dart';
import 'package:nyalcf/ui/auth/login.dart';
import 'package:nyalcf/ui/auth/register.dart';
import 'package:nyalcf/ui/home.dart';
import 'package:nyalcf/ui/panel/console.dart';
import 'package:nyalcf/ui/panel/home.dart';
import 'package:nyalcf/ui/panel/proxies.dart';
import 'package:nyalcf/ui/setting/injector.dart';

void main() {
  runApp(const App());

  doWhenWindowReady(() {
    const initialSize = Size(800, 500);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Nya LoCyanFrp! - LCF启动器';
    appWindow.show();
  });
}

final Setting? _settings = SettingStorage.read();

class App extends StatelessWidget {
  const App({super.key});

  final title = 'Nya LoCyanFrp!';

  /// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 初始化配置文件
    SettingStorage.init();
    FrpcManagerStorage.init();

    ThemeData _theme_data;

    final bool isDarkMode = (Theme.of(context).brightness == Brightness.dark ||
        Theme.of(context).colorScheme.brightness == Brightness.dark) ||
        SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ||
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    print('dark mode: ${isDarkMode}');

    /// 判定是否需要切换暗色主题
    if (((_settings?.theme_auto ?? true) && isDarkMode) ||
        (_settings?.theme_dark ?? false)) {
      _theme_data = ThemeData.dark(useMaterial3: true);
    } else if ((_settings?.theme_light_seed_enable ?? false)) {
      _theme_data = ThemeData(
          useMaterial3: true,
          fontFamily: 'HarmonyOS Sans',
          colorScheme: ColorScheme.fromSeed(
            seedColor:
                Color('0x${_settings?.theme_light_seed ?? '66ccff'}' as int),
          ));
    } else {
      _theme_data = ThemeData(
        useMaterial3: true,
        fontFamily: 'HarmonyOS Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink.shade300,
        ).copyWith(
          primary: Colors.pink.shade500,
          secondary: Colors.pink.shade400,
        ),
      );
    }

    Get.put(UserController());
    return GetMaterialApp(
      title: 'Nya LoCyanFrp!',
      routes: {
        '/': (context) => Home(title: title),
        '/login': (context) => Login(title: title),
        '/register': (context) => Register(title: title),
        '/panel/home': (context) => PanelHome(title: title),
        '/panel/proxies': (context) => PanelProxies(title: title),
        '/panel/console': (context) => PanelConsole(title: title),
        '/setting': (context) => SettingInjector(title: title),
      },
      theme: _theme_data,
    );
  }
}
