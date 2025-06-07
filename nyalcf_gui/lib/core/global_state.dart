import 'package:get/get.dart';

class GlobalState extends GetxController {
  static bool deeplinkStartup = false;
  static final title = 'Nya LoCyanFrp!';

  var loading = false.obs;

  var uiMode = UiMode.material.obs;
  var themeMode = ThemeMode.light.obs;
}

enum UiMode {
  material,
  fluent,
}

enum ThemeMode {
  light,
  dark,
}