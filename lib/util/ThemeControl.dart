import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ThemeControl {
  static void autoSet() {
    final bool isDarkMode =
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    switchDarkTheme(isDarkMode);
  }

  static void switchDarkTheme(bool value) {
    if (value) {
      Get.changeTheme(dark);
      print('Change to dark theme / ${value}');
    } else {
      Get.changeTheme(light);
      print('Change to light theme / ${value}');
    }
  }

  static final dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'HarmonyOS Sans',
    brightness: Brightness.dark,
  );
  static final light = ThemeData(
    useMaterial3: true,
    fontFamily: 'HarmonyOS Sans',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink.shade300,
    ).copyWith(
      primary: Colors.pink.shade400,
      secondary: Colors.pink.shade300,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.pink.shade100,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.pink.shade200,
    ),
  );
}
