import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/models/update_info_model.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/launcher/update.dart';
import 'package:nyalcf/utils/universe.dart';
import 'package:url_launcher/url_launcher.dart';

class Updater {
  /// 获取内部包版本
  static UpdateInfoModel? uIf = UpdateInfoModel(
      version: Universe.appVersion, tag: Universe.appVersion, downloadUrl: []);

  static void startUp() async {
    Logger.info('Checking update...');

    /// 获取远程源版本
    final remote = await LauncherUpdateDio().getUpdate();
    if (remote.status) {
      uIf = remote.data['update_info'];
    } else {
      Logger.warn('Get remote version info failed.');
    }

    if (check()) {
      showDialog();
    } else {
      Logger.info('You are running latest version.');
      Future.delayed(const Duration(hours: 1), () {
        startUp();
      });
    }
  }

  static bool check() {
    Logger.debug(
        '${uIf?.version} | v${Universe.appVersion}+${Universe.appBuildNumber}');

    /// 比对是否一致
    if (uIf?.version != null &&
        'v${Universe.appVersion}+${Universe.appBuildNumber}' != uIf?.version &&
        'v${Universe.appVersion}' != uIf?.version) {
      Logger.info('New version: ${uIf?.version}');
      return true;
    }
    return false;
  }

  static void showDialog() {
    Get.dialog(AlertDialog(
      icon: const Icon(Icons.update),
      title: const Text('好耶！是新版本！'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('当前版本：v${Universe.appVersion}+${Universe.appBuildNumber}'),
          Text('新版本：${uIf?.version}'),
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
