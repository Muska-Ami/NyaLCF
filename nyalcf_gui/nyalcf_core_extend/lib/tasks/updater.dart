// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/update_info_model.dart';
import 'package:nyalcf_core/network/client/common/launcher.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_core_extend/tasks/basic.dart';
import 'package:nyalcf_core_extend/utils/universe.dart';

class TaskUpdater extends TaskBasic {
  static UpdateInfoModel uIf = UpdateInfoModel(
    version: Universe.appVersion,
    tag: Universe.appVersion,
    buildNumber: Universe.appBuildNumber,
    downloadUrl: [],
  );

  @override
  void startUp({Function? callback}) async {
    if (callback != null) this.callback = callback;
    loading.value = true;
    Logger.info('Checking update...');

    // 获取远程源版本
    final remote = await Launcher().latestVersion();
    if (remote != null) {
      // 远程源版本获取到的时候才检测
      uIf = remote;
      if (check()) {
        showDialog();
      } else {
        Logger.info('You are running latest version.');
        // 计划下一次检查
        if (this.callback != null) this.callback!();
      }
    } else {
      Logger.warn('Get remote version info failed.');
    }
    loading.value = false;
  }

  static bool check() {
    Logger.debug(
      '${uIf.version},'
      ' ${uIf.buildNumber} | v${Universe.appVersion},'
      ' ${Universe.appBuildNumber}',
    );

    // 比对是否一致
    // 先判断大版本号，大版本号不一致就不检查构建号了
    // 大版本号一致再检查构建号
    if ('v${Universe.appVersion}' != uIf.version) {
      Logger.info('New version: ${uIf.version}, ${Universe.appBuildNumber}');
      return true;
    } else if (uIf.buildNumber != Universe.appBuildNumber) {
      // 这里的逻辑不能和上面的用一个if
      Logger.info('New version: ${uIf.version}, ${Universe.appBuildNumber}');
      return true;
    } else {
      return false;
    }
  }

  static void showDialog() {
    Get.dialog(AlertDialog(
      icon: const Icon(Icons.update),
      title: const Text('好耶！是新版本！'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('当前版本：v${Universe.appVersion} (+${Universe.appBuildNumber})'),
          Text('更新版本：${uIf.version} (+${uIf.buildNumber})'),
          const Text('是否打开下载界面喵？'),
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: const Text(
              '取消',
            ),
            onPressed: () async {
              Get.close(0);
            }),
        TextButton(
          child: const Text(
            '确定',
          ),
          onPressed: () async {
            const url = 'https://nyalcf.1l1.icu/download';
            if (!await launchUrl(Uri.parse(url))) {
              Get.snackbar(
                '发生错误',
                '无法打开网页，请检查设备是否存在WebView',
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
            } else {
              Get.close(0);
            }
          },
        ),
      ],
    ));
  }
}
