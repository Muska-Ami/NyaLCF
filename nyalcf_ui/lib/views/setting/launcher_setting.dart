import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/launcher_setting_controller.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/launcher/launcher.dart';
import 'package:nyalcf_core/utils/path_provider.dart';
import 'package:nyalcf_core/utils/theme_control.dart';
import 'package:nyalcf_core/utils/universe.dart';
import 'package:nyalcf_core/utils/updater.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherSetting {
  final DSettingLauncherController dsctr = Get.find();
  final lcs = LauncherConfigurationStorage();

  static final String? _supportPath = PathProvider.appSupportPath;

  TextEditingController get _textEditingController =>
      TextEditingController(text: lcs.getThemeLightSeedValue());

  Widget widget() {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('启动'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  padding: const EdgeInsets.only(left: 30.0, right: 50.0),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.file_open),
                                title: Text('自动启动'),
                              ),
                            ),
                            Switch(
                              value: dsctr.autostart.value,
                              onChanged: (value) async {
                                if (Platform.isWindows) {
                                  dsctr.setAutostart(value);
                                } else {
                                  Get.snackbar(
                                    '呜哇！',
                                    '这个功能貌似只能在Windows系统上使用，其他平台尚在开发喵~',
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.color_lens),
                  title: Text('主题'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  padding: const EdgeInsets.only(left: 30.0, right: 50.0),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '自定义主题设置',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.auto_awesome),
                                title: Text('自动设置主题'),
                              ),
                            ),
                            Switch(
                              value: dsctr.themeAuto.value,
                              onChanged: (value) async {
                                lcs.setThemeAuto(value);
                                lcs.save();
                                dsctr.themeAuto.value = value;
                                dsctr.loadx();
                                if (value) {
                                  ThemeControl.autoSet();
                                } else if (lcs.getThemeDarkEnable()) {
                                  // 暗色
                                  Get.changeThemeMode(ThemeMode.dark);
                                  Get.forceAppUpdate();
                                } else {
                                  // 亮色
                                  Get.changeThemeMode(ThemeMode.light);
                                  if (lcs.getThemeLightSeedEnable()) {
                                    // 自定义
                                    Get.changeTheme(ThemeControl.custom);
                                  } else {
                                    Get.changeTheme(ThemeControl.light);
                                  }
                                  Get.forceAppUpdate();
                                }
                              },
                            ),
                          ],
                        ),
                        dsctr.switchThemeDark.value,
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.colorize),
                                title: Text('浅色主题自定义主题色种子'),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        controller: _textEditingController,
                                        decoration: const InputDecoration(
                                          labelText: '十六进制颜色',
                                        ),
                                        onSubmitted: (value) async =>
                                            _customThemeColorSeed(value),
                                      ),
                                    ),
                                    Transform.translate(
                                      offset: const Offset(0, 5),
                                      child: ElevatedButton(
                                        onPressed: () async =>
                                            _customThemeColorSeed(
                                                _textEditingController.text),
                                        child: const Text('保存'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Switch(
                              value: dsctr.themeLightSeedEnable.value,
                              onChanged: (value) async {
                                lcs.setThemeLightSeedEnable(value);
                                Logger.debug(lcs.getThemeLightSeedEnable());
                                lcs.save();
                                // 必须要手动模式才执行操作
                                if (!lcs.getThemeAuto()) {
                                  if (value) {
                                    // 自定义
                                    Get.changeThemeMode(ThemeMode.light);
                                    Get.changeTheme(ThemeControl.custom);
                                  } else if (lcs.getThemeDarkEnable()) {
                                    // 暗色
                                    Get.changeThemeMode(ThemeMode.dark);
                                  } else {
                                    // 亮色
                                    Get.changeThemeMode(ThemeMode.light);
                                    Get.changeTheme(ThemeControl.light);
                                  }
                                }
                                Get.forceAppUpdate();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('调试'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  padding: const EdgeInsets.only(left: 30.0, right: 50.0),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '启动器调试功能',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.file_open),
                                title: Text('开启 DEBUG 模式'),
                              ),
                            ),
                            Switch(
                              value: dsctr.debugMode.value,
                              onChanged: (value) async {
                                lcs.setDebug(value);
                                lcs.save();
                                dsctr.debugMode.value = value;
                              },
                            ),
                          ],
                        ),
                        Text(
                          '日志',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  OpenFilex.open(
                                    '$_supportPath/run.log',
                                  );
                                },
                                child: const Text('打开日志文件'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  File('$_supportPath/run.log')
                                      .delete()
                                      .then((value) => Get.snackbar(
                                            '好耶！',
                                            '已清除日志文件喵',
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                          ))
                                      .onError((error, stackTrace) {
                                    Logger.error(error);
                                    return Get.snackbar(
                                      '坏！',
                                      '发生了一点小问题QAQ $error}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                    );
                                  });
                                },
                                child: const Text('清除日志'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('软件信息'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SelectableText('通用软件名称：Nya LoCyanFrp! 乐青映射启动器'),
                      SelectableText('内部软件名称：${Universe.appName}'),
                      SelectableText('内部软件包名：${Universe.appPackageName}'),
                      SelectableText(
                          '软件版本：${Universe.appVersion} (+${Universe.appBuildNumber})'),
                      const SelectableText('著作权信息：登记中'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      final remote = await UpdateLauncher().getUpdate();
                      if (remote.status) {
                        Updater.uIf = remote.data['update_info'];
                        if (Updater.check()) Updater.showDialog();
                      } else {
                        Get.snackbar(
                          '发生错误',
                          '无法检查版本更新：${remote.message}',
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: const Duration(milliseconds: 300),
                        );
                      }
                    },
                    child: const Text('检查更新'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0),
                  child: const Text(
                    'Powered by Flutter framework.',
                    style: TextStyle(
                      color: Color.fromRGBO(57, 186, 255, 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('帮助我们做的更好'),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                          'Nya LoCyanFrp! 是免费开源的，欢迎向我们提交BUG或新功能请求。您可以在GitHub上提交Issue来向我们反馈。'),
                      TextButton(
                        child: const ListTile(
                          leading: Icon(Icons.link),
                          title: Text(
                            'https://github.com/Muska-Ami/NyaLCF/issues',
                            style: TextStyle(color: Colors.pink),
                          ),
                        ),
                        onPressed: () async {
                          const url =
                              'https://github.com/Muska-Ami/NyaLCF/issues';
                          if (!await launchUrl(Uri.parse(url))) {
                            Get.snackbar(
                              '发生错误',
                              '无法打开网页，请检查设备是否存在WebView',
                              snackPosition: SnackPosition.BOTTOM,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _customThemeColorSeed(String code) {
    if (code.startsWith('#')) {
      code = code.substring(1); // 移除 # 符号
    } else {
      code = code;
    }
    if (code.length == 6 || code.length == 8) {
      lcs.setThemeLightSeedValue(code);
      lcs.save();
      Logger.debug(code);
      // 检查是否启用
      // 必须要手动模式才执行操作
      if (lcs.getThemeLightSeedEnable() && !lcs.getThemeAuto()) {
        Get.changeThemeMode(ThemeMode.light);
        Get.changeTheme(ThemeControl.custom);
        Get.forceAppUpdate();
      }
    } else {
      Get.snackbar(
        '大笨蛋！',
        '这不是有效的十六进制颜色代码哦！',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
  }
}
