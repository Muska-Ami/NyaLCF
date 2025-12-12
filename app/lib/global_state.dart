import 'package:get/get.dart';

import 'package:core/io/process/manager.dart';

class GlobalState extends GetxController {
  static bool deeplinkStartup = false;
  static final title = 'Nya LoCyanFrp!';

  var loading = false.obs;

  var themeMode = ThemeMode.light.obs;

  static var processManager = ProcessManager();
}

enum ThemeMode {
  light,
  dark,
}
