import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/path_provider.dart';
import 'package:nyalcf_core/utils/theme_control.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

class DSettingLauncherController extends GetxController {
  final _lcs = LauncherConfigurationStorage();
  final _supportPath = PathProvider.appSupportPath;

  var autostart = false.obs;

  var autoSign = false.obs;

  var themeAuto = false.obs;
  var themeDark = false.obs;
  var themeLightSeed = ''.obs;
  var themeLightSeedEnable = false.obs;

  var switchThemeDark = const Row().obs;

  var debugMode = false.obs;

  load() async {
    autostart.value = _getAutostartInkExist();

    autoSign.value = _lcs.getAutoSign();

    themeLightSeed.value = _lcs.getThemeLightSeedValue();
    themeLightSeedEnable.value = _lcs.getThemeLightSeedEnable();
    // 新配置
    themeAuto.value = _lcs.getThemeAuto();
    themeDark.value = _lcs.getThemeDarkEnable();
    debugMode.value = _lcs.getDebug();
    loadx();
  }

  void loadx() {
    if (!(themeAuto.value)) {
      Logger.debug('Auto theme is disabled, add button to switch theme');
      switchThemeDark.value = Row(
        children: <Widget>[
          const Expanded(
            child: ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('深色主题'),
            ),
          ),
          Switch(
            value: themeDark.value,
            onChanged: switchDarkTheme,
          ),
        ],
      );
    } else {
      switchThemeDark.value = const Row();
    }
  }

  void switchDarkTheme(value) async {
    _lcs.setThemeDarkEnable(value);
    _lcs.save();
    themeDark.value = value;
    if (value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      if (_lcs.getThemeLightSeedEnable()) Get.changeTheme(ThemeControl.custom);
    }
    Get.forceAppUpdate();
    loadx();
    // ThemeControl.switchDarkTheme(value);
  }

  void setAutostart(bool value) async {
    loading.value = true;
    final userProgramPath = Directory(_supportPath!).parent.parent.path;
    final startUpPath =
        '$userProgramPath/Microsoft/Windows/Start Menu/Programs/Startup';
    final lnkFile = '$startUpPath/nyanana.lnk';
    final executablePath = Platform.resolvedExecutable;
    if (value) {
      Logger.debug('Create lnk file');
      Logger.debug('$lnkFile -> $executablePath');
      await _createShortcut(executablePath, lnkFile);
    } else {
      Logger.debug('Remove lnk file');
      await File(lnkFile).delete();
    }
    autostart.value = _getAutostartInkExist();
    loading.value = false;
  }

  bool _getAutostartInkExist() {
    final userProgramPath = Directory(_supportPath!).parent.parent.path;
    final startUpPath =
        '$userProgramPath/Microsoft/Windows/Start Menu/Programs/Startup';
    final lnkFile = '$startUpPath/nyanana.lnk';
    return File(lnkFile).existsSync();
  }

  Future<void> _createShortcut(String targetPath, String shortcutPath) async {
    // 构建 PowerShell 脚本内容
    var powerShellScript = '''
\$targetPath = "${targetPath.replaceAll('\\', '\\\\')}"
\$shortcutPath = "${shortcutPath.replaceAll('\\', '\\\\')}"
\$WScriptShell = New-Object -ComObject WScript.Shell
\$Shortcut = \$WScriptShell.CreateShortcut(\$shortcutPath)
\$Shortcut.TargetPath = \$targetPath
\$Shortcut.Save()
  ''';

    // 保存 PowerShell 脚本内容到临时文件
    var scriptFile = File('temp.ps1');
    await scriptFile.writeAsString(powerShellScript);

    // 构建执行 PowerShell 脚本的命令
    var cmdCommand =
        'powershell.exe -ExecutionPolicy Bypass -File ${scriptFile.path}';

    // 执行命令
    var result = await Process.run('cmd.exe', ['/c', cmdCommand]);

    // 打印结果
    Logger.debug('[PSOUT] ${result.stdout}');

    if (result.exitCode == 0) {
      Logger.info('Shortcut created successfully.');
    } else {
      Logger.error('Failed to create shortcut: ${result.stderr}');
    }

    // 删除临时 PowerShell 脚本文件
    await scriptFile.delete();
  }
}
