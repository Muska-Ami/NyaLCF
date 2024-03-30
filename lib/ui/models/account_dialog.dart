import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/console_controller.dart';
import 'package:nyalcf/controllers/panel_controller.dart';
import 'package:nyalcf/controllers/proxies_controller.dart';
import 'package:nyalcf/storages/stores/user_info_storage.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDialogX {
  const AccountDialogX({required this.context});

  final BuildContext context;

  Widget build() {
    return SimpleDialog(
      title: const Text('小可爱，喵呜？'),
      children: <Widget>[
        SimpleDialogOption(
            child: const ListTile(
              leading: Icon(Icons.redo),
              title: Text('退出登录'),
            ),
            onPressed: () async {
              try {
                await UserInfoStorage.sigo();
              } catch (e) {
                Get.snackbar(
                  '发生错误',
                  e.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                );
              }
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
              Get.toNamed('/');
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
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
      ],
    );
  }
}
