import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolDialogX {
  const ToolDialogX({required this.context});

  final BuildContext context;

  Widget build() {
    return SimpleDialog(
      title: const Text('请问您今天想做点什么？'),
      children: <Widget>[
        SimpleDialogOption(
            child: const Text('LoCyanFrp Website'),
            onPressed: () async {
              const url = 'https://www.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                Get.snackbar(
                  '发生错误',
                  '无法打开网页，请检查设备是否存在WebView',
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                );
              }
            }),
        SimpleDialogOption(
            child: const Text('LoCyanFrp Dashboard'),
            onPressed: () async {
              const url = 'https://dashboard.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                Get.snackbar(
                  '发生错误',
                  '无法打开网页，请检查设备是否存在WebView',
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                );
              }
            }),
        SimpleDialogOption(
            child: const Text('LoCyanFrp Dashboard (Preview)'),
            onPressed: () async {
              const url = 'https://preview.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                Get.snackbar(
                  '发生错误',
                  '无法打开网页，请检查设备是否存在WebView',
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                );
              }
            }),
        SimpleDialogOption(
            child: const Text('中国内网穿透联盟 (China Frp Union)'),
            onPressed: () async {
              const url = 'https://xn--v6qw21h0gd43u.xn--fiqs8s/';
              if (!await launchUrl(Uri.parse(url))) {
                Get.snackbar(
                  '发生错误',
                  '无法打开网页，请检查设备是否存在WebView',
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                );
              }
            }),
      ],
    );
  }
}
