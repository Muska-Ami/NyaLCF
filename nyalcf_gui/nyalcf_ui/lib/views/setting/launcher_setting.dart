// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/network/client/common/launcher.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/tasks/updater.dart';
import 'package:nyalcf_core_extend/utils/color_utils.dart';
import 'package:nyalcf_core_extend/utils/theme_control.dart';
import 'package:nyalcf_core_extend/utils/universe.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/launcher_setting_controller.dart';
import 'package:nyalcf_ui/models/color_pick_dialog.dart';

class LauncherSetting {
  LauncherSetting({required this.context});
  final BuildContext context;

  final LauncherSettingLauncherController _lsCtr = Get.find();
  final _lcs = LauncherConfigurationStorage();

  static final String? _supportPath = appSupportPath;

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
                  leading: Icon(Icons.amp_stories),
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
                              value: _lsCtr.autostart.value,
                              onChanged: (value) async {
                                if (Platform.isWindows) {
                                  _lsCtr.setAutostart(value);
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
                        Text(
                          '您可能需要重启启动器才能应用此更改',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.brightness_auto),
                                title: Text('自动设置主题'),
                              ),
                            ),
                            Switch(
                              value: _lsCtr.themeAuto.value,
                              onChanged: (value) async {
                                _lcs.setThemeAuto(value);
                                _lcs.save();
                                _lsCtr.themeAuto.value = value;
                                _lsCtr.loadx();
                                if (value) {
                                  ThemeControl.autoSet();
                                } else {
                                  ThemeControl.switchDarkTheme(
                                      _lcs.getThemeDarkEnable());
                                }
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _lsCtr.switchThemeDarkOption.value,
                          child: Row(
                            children: <Widget>[
                              const Expanded(
                                child: ListTile(
                                  leading: Icon(Icons.dark_mode),
                                  title: Text('深色主题'),
                                ),
                              ),
                              Switch(
                                value: _lsCtr.themeDark.value,
                                onChanged: _lsCtr.switchDarkTheme,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: ListTile(
                                leading: Icon(Icons.auto_fix_normal),
                                title: Text('Monet 取色'),
                              ),
                            ),
                            Switch(
                              value: _lsCtr.themeMonet.value,
                              onChanged: (value) async {
                                _lcs.setThemeMonet(value);
                                _lcs.save();
                                _lsCtr.themeMonet.value = value;
                                _lsCtr.loadx();
                              },
                            ),
                          ],
                        ),
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
                                    // Expanded(
                                    //   child: TextField(
                                    //     controller: _textEditingController,
                                    //     decoration: const InputDecoration(
                                    //       labelText: '十六进制颜色',
                                    //     ),
                                    //     onSubmitted: (value) async => _customThemeColorSeed(value)),
                                    // ),
                                    // Transform.translate(
                                    //   offset: const Offset(0, 5),
                                    //   child: ElevatedButton(
                                    //     onPressed: () async => _customThemeColorSeed(_textEditingController.text),
                                    //     child: const Text('保存'),
                                    //   ),
                                    // ),
                                    Transform.translate(
                                      offset: const Offset(80, 6),
                                      child: ElevatedButton(
                                        onPressed: () async => Get.dialog(
                                          colorPickDialog(
                                            context,
                                            pickerColor: ColorUtils.hexToColor(
                                                _lcs.getThemeLightSeedValue()),
                                            onColorChanged: (value) {
                                              _customThemeColorSeed(value);
                                            },
                                          ),
                                        ),
                                        child: const Text('选取颜色'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Switch(
                              value: _lsCtr.themeLightSeedEnable.value,
                              onChanged: (value) async {
                                _lcs.setThemeLightSeedEnable(value);
                                Logger.debug(_lcs.getThemeLightSeedEnable());
                                _lcs.save();
                                _lsCtr.themeLightSeedEnable.value = value;
                                // 必须要手动模式才执行操作
                                if (!_lcs.getThemeAuto()) {
                                  if (value && !_lcs.getThemeDarkEnable()) {
                                    // 自定义
                                    ThemeControl.autoSet();
                                  } else {
                                    ThemeControl.switchDarkTheme(
                                        _lcs.getThemeDarkEnable());
                                  }
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
                  leading: Icon(Icons.control_camera),
                  title: Text('控制台'),
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
                                leading: Icon(Icons.error_outline),
                                title: Text('错误检测及提示'),
                              ),
                            ),
                            Switch(
                              value: _lsCtr.consoleKindTip.value,
                              onChanged: (value) async {
                                _lcs.setConsoleKindTip(value);
                                _lcs.save();
                                _lsCtr.consoleKindTip.value = value;
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
                  leading: Icon(Icons.donut_large),
                  title: Text('杂项'),
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
                                leading: Icon(Icons.auto_awesome),
                                title: Text('自动签到'),
                              ),
                            ),
                            Switch(
                              value: _lsCtr.autoSign.value,
                              onChanged: (value) async {
                                _lsCtr.autoSign.value = value;
                                _lcs.setAutoSign(value);
                                _lcs.save();
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
                              value: _lsCtr.debugMode.value,
                              onChanged: (value) async {
                                _lcs.setDebug(value);
                                _lcs.save();
                                _lsCtr.debugMode.value = value;
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: SelectableText(
                                    '日志保存路径：$_supportPath${Platform.isWindows ? '\\' : '/'}logs'),
                              ),
                              Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () async {
                                      OpenFilex.open(
                                          '$_supportPath/logs/run.log');
                                    },
                                    child: const Text('打开日志文件'),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        File('$_supportPath/logs/run.log')
                                            .delete()
                                            .then((value) => Get.snackbar(
                                                  '好耶！',
                                                  '已清除日志文件喵',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                ))
                                            .onError((error, stackTrace) {
                                          Logger.error(error, t: stackTrace);
                                          return Get.snackbar(
                                            '坏！',
                                            '发生了一点小问题QAQ $error',
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                          );
                                        });
                                      },
                                      child: const Text('清除日志'),
                                    ),
                                  ),
                                ],
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
                      const SelectableText(
                          'Copyright 2023 © 夏沫花火zzz🌙，以及感谢社区贡献者的无私奉献。'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      loading.value = true;
                      final remote = await Launcher().latestVersion();
                      if (remote != null) {
                        TaskUpdater.uIf = remote;
                        if (TaskUpdater.check()) TaskUpdater.showDialog();
                      } else {
                        Get.snackbar(
                          '发生错误',
                          '无法检查版本更新，请求失败惹呜',
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: const Duration(milliseconds: 300),
                        );
                      }
                      loading.value = false;
                    },
                    child: const Text('检查更新'),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
                        ),
                        onPressed: () => Get.toNamed('/license'
                            // () => LicensePage(
                            //   applicationVersion: Universe.appVersion,
                            //   applicationIcon: SizedBox(
                            //     width: 48,
                            //     child: Image.asset('icon.ico'),
                            //   ),
                            // ),
                            ),
                        child: const Text('开源许可证'),
                      ),
                    ),
                  ],
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

  void _customThemeColorSeed(Color color) {
    String code = ColorUtils.colorToHex(color);

    _lcs.setThemeLightSeedValue(code);
    _lcs.save();
    Logger.debug(code);
    // 检查是否启用
    // 必须要手动模式才执行操作
    if (_lcs.getThemeLightSeedEnable() &&
        !_lcs.getThemeAuto() &&
        !_lcs.getThemeDarkEnable()) {
      Get.changeThemeMode(ThemeMode.light);
      Get.changeTheme(ThemeControl.custom);
    }
  }
}
