import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget defenderDialog() {
  return AlertDialog(
    title: const Text('Frpc 无法正常启动'),
    content: const Text(
        '检测到 Frpc 启动被反垃圾/杀毒软件拦截，如需继续启动，请将 Nya LoCyanFrp 下载的 Frpc 加入白名单。'),
    actions: [
      ElevatedButton(
        onPressed: () async => Get.close(0),
        child: const Text('确定'),
      ),
    ],
  );
}
