import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolDialog {
  const ToolDialog({required this.context});

  final context;

  Widget build() {
    return SimpleDialog(
      title: const Text("请问您今天想做点什么？"),
      children: <Widget>[
        SimpleDialogOption(
            child: const Text("访问LocyanFrp官方网站"),
            onPressed: () async {
              const url = 'https://www.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                const snackBar = SnackBar(
                  content: Text("无法打开网页，请检查设备是否存在WebView"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
      ],
    );
  }
}
