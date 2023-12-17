import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/user.dart';
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
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({super.key});

  final title = "NyaLCF";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return GetMaterialApp(
        title: 'NyaLCF',
        routes: {
          "/": (context) => Home(title: title),
          "/login": (context) => Login(title: title),
          "/register": (context) => Register(title: title),
          "/panel/home": (context) => PanelHome(title: title),
          "/panel/proxies": (context) => PanelProxies(title: title),
          "/panel/console": (context) => PanelConsole(title: title),
          "/setting/launcher": (context) => SettingInjector(title: title),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
          fontFamily: 'HarmonyOS Sans'
        ));
  }
}
