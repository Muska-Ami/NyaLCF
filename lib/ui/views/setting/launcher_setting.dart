import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/launcher_setting_controller.dart';
import 'package:nyalcf/storages/configurations/launcher_configuration_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nyalcf/utils/path_provider.dart';

class LauncherSetting {
  final DSettingLauncherController dsctr = Get.find();
  final lcs = LauncherConfigurationStorage();

  static final String? _supportPath = PathProvider.appSupportPath;

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
                                Get.forceAppUpdate();
                                // ThemeControl.autoSet();
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
                                child: const TextField(
                                  decoration: InputDecoration(
                                    labelText: '十六进制颜色',
                                  ),
                                  readOnly: true,
                                ),
                              ),
                            ),
                            Switch(
                              value: dsctr.themeLightSeedEnable.value,
                              onChanged: null,
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
                                  File('$_supportPath/run.log').delete().then(
                                        (value) =>
                                            Get.snackbar('好耶！', '已清除日志文件喵'),
                                      );
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
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SelectableText('通用软件名称：Nya LoCyanFrp! 乐青映射启动器'),
                        SelectableText('内部软件名称：${dsctr.appName}'),
                        SelectableText('内部软件包名：${dsctr.appPackageName}'),
                        SelectableText(
                            '软件版本：${dsctr.appVersion} (+${dsctr.appBuildNumber})'),
                        const SelectableText('著作权信息：登记中'),
                      ],
                    ),
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
                          'Nya LoCyanFrp! 是免费开源的，欢迎向我们提交BUG或新功能请求。您可以在GitHub上提交Issues来向我们反馈。'),
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
}
