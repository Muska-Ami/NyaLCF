import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolDialogX {
  const ToolDialogX({required this.context});

  final context;

  Widget build() {
    return SimpleDialog(
      title: const Text("请问您今天想做点什么？"),
      children: <Widget>[
        SimpleDialogOption(
            child: const Text("LoCyanFrp Website"),
            onPressed: () async {
              const url = 'https://www.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                const snackBar = SnackBar(
                  content: Text("无法打开网页，请检查设备是否存在WebView"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        SimpleDialogOption(
            child: const Text("LoCyanFrp Dashboard"),
            onPressed: () async {
              const url = 'https://dashboard.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                const snackBar = SnackBar(
                  content: Text("无法打开网页，请检查设备是否存在WebView"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        SimpleDialogOption(
            child: const Text("LoCyanFrp Dashboard (Preview)"),
            onPressed: () async {
              const url = 'https://preview.locyanfrp.cn';
              if (!await launchUrl(Uri.parse(url))) {
                const snackBar = SnackBar(
                  content: Text("无法打开网页，请检查设备是否存在WebView"),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }),
        SimpleDialogOption(
            child: const Text("中国内网穿透联盟 (China Frp Union)"),
            onPressed: () async {
              const url = 'https://xn--v6qw21h0gd43u.xn--fiqs8s/';
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
