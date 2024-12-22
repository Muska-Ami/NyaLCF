// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/instance.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/home_panel_controller.dart';
import 'package:nyalcf_ui/controllers/proxies_controller.dart';
import 'package:nyalcf_ui/views/home.dart';

Widget accountDialog(BuildContext context) {
  return SimpleDialog(
    title: const Text('小可爱，喵呜？'),
    children: <Widget>[
      SimpleDialogOption(
          child: const ListTile(
            leading: Icon(Icons.redo),
            title: Text('退出登录'),
          ),
          onPressed: () async {
            loading.value = true;
            try {
                UserInfoStorage.logout();
                PrefsInstance.clear();
                final HomeController hc = Get.put(HomeController());
                hc.load(force: true);
                Get.toNamed('/');
                Logger.info('Dispose controllers');
                try {
                  final HomePanelController ctr = Get.find();
                  ctr.dispose();
                } catch (ignore) {
                  //
                }
                try {
                  final ProxiesController ctr = Get.find();
                  ctr.dispose();
                } catch (ignore) {
                  //
                }
                try {
                  final ConsoleController ctr = Get.find();
                  ctr.dispose();
                } catch (ignore) {
                  //
                }
            } catch (e) {
              Get.snackbar(
                '发生错误',
                e.toString(),
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
            }
            loading.value = false;
          }),
      SimpleDialogOption(
          child: const ListTile(
            leading: Icon(Icons.face),
            title: Text('编辑头像'),
          ),
          onPressed: () async {
            const url = 'https://cravatar.cn';
            if (!await launchUrl(Uri.parse(url))) {
              const snackBar = SnackBar(
                content: Text('无法打开网页，请检查设备是否存在 WebView'),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Logger.error(
                    'Context not mounted while executing a async function!');
              }
            }
          }),
    ],
  );
}
