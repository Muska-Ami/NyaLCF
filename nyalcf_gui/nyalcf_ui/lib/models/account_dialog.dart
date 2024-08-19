import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/panel_controller.dart';
import 'package:nyalcf_ui/controllers/proxies_controller.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_ui/views/home.dart';

class AccountDialogX {
  const AccountDialogX({required this.context});

  final BuildContext context;

  Widget build() {
    final UserController uCtr = Get.find();

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
                final logout =
                    await UserInfoStorage.sigo(uCtr.user, uCtr.token);
                if (logout) {
                  final HC hc = Get.put(HC());
                  hc.load(force: true);
                  Get.toNamed('/');
                  Logger.info('Dispose controllers');
                  try {
                    final DPanelController dpctr = Get.find();
                    dpctr.dispose();
                  } catch (ignore) {
                    //
                  }
                  try {
                    final ProxiesController pctr = Get.find();
                    pctr.dispose();
                  } catch (ignore) {
                    //
                  }
                  try {
                    final ConsoleController cctr = Get.find();
                    cctr.dispose();
                  } catch (ignore) {
                    //
                  }
                } else {
                  Get.snackbar(
                    '发生错误',
                    '请求登出失败，请重试 oxo',
                    snackPosition: SnackPosition.BOTTOM,
                    animationDuration: const Duration(milliseconds: 300),
                  );
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
                  content: Text('无法打开网页，请检查设备是否存在WebView'),
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
}
