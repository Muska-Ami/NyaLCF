// Dart imports:
import 'dart:io';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/utils/theme_control.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

class LauncherSettingLauncherController extends GetxController {
  final _lcs = LauncherConfigurationStorage();
  final _supportPath = appSupportPath;

  /// <Rx>是否自动启动
  var autostart = false.obs;

  /// <Rx>是否自动签到
  var autoSign = false.obs;

  /// <Rx>是否自动设置主题
  var themeAuto = false.obs;

  /// <Rx>是否 Monet 取色
  var themeMonet = false.obs;

  /// <Rx>是否启用暗色模式
  var themeDark = false.obs;

  /// <Rx>浅色模式自定义颜色种子
  var themeLightSeed = ''.obs;

  /// <Rx>是否启用浅色模式自定义颜色种子
  var themeLightSeedEnable = false.obs;

  /// <Rx>切换是否启用深色模式的组件
  var switchThemeDarkOption = false.obs;

  /// <Rx>是否启用错误帮助提示
  var consoleKindTip = false.obs;

  /// <Rx>是否启用 DEBUG 模式
  var debugMode = false.obs;

  /// 加载控制器
  load() async {
    autostart.value = _getAutostartInkExist();

    autoSign.value = _lcs.getAutoSign();

    themeLightSeed.value = _lcs.getThemeLightSeedValue();
    themeLightSeedEnable.value = _lcs.getThemeLightSeedEnable();
    // 新配置
    themeAuto.value = _lcs.getThemeAuto();
    themeMonet.value = _lcs.getThemeMonet();
    themeDark.value = _lcs.getThemeDarkEnable();
    consoleKindTip.value = _lcs.getConsoleKindTip();
    debugMode.value = _lcs.getDebug();
    loadx();
  }

  /// 这也是加载，不过有其他调用独立出来复用的
  void loadx() {
    if (!(themeAuto.value)) {
      Logger.debug('Auto theme is disabled, add button to switch theme');
      switchThemeDarkOption.value = true;
    } else {
      switchThemeDarkOption.value = false;
    }
  }

  /// 切换是否使用暗色主题
  void switchDarkTheme(value) async {
    _lcs.setThemeDarkEnable(value);
    _lcs.save();
    themeDark.value = value;
    ThemeControl.switchDarkTheme(value);
    loadx();
    // ThemeControl.switchDarkTheme(value);
  }

  /// 设置是否自动启动启动器
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

  /// 获取自动启动项的 .ink 文件是否存在
  bool _getAutostartInkExist() {
    final userProgramPath = Directory(_supportPath!).parent.parent.path;
    final startUpPath =
        '$userProgramPath/Microsoft/Windows/Start Menu/Programs/Startup';
    final lnkFile = '$startUpPath/nyanana.lnk';
    return File(lnkFile).existsSync();
  }

  /// 创建自动启动项的 .ink 文件
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
