import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/consoleController.dart';
import 'package:nyalcf/controllers/panelController.dart';
import 'package:nyalcf/controllers/proxiesController.dart';
import 'package:nyalcf/io/userInfoStorage.dart';
import 'package:nyalcf/utils/Logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountDialogX {
  const AccountDialogX({required this.context});

  final context;

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
                  animationDuration: Duration(milliseconds: 300),
                );
              }
              Logger.info('Dispose controllers');
              try {
                final DPanelController dp_c = Get.find();
                dp_c.dispose();
              } catch (ignore) {}
              try {
                final ProxiesController p_c = Get.find();
                p_c.dispose();
              } catch (ignore) {}
              try {
                final ConsoleController c_c = Get.find();
                c_c.dispose();
              } catch (ignore) {}
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
