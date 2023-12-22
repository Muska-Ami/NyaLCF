import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/controller/frpc.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';

class ProcessManager {

  final FrpcController f_c = Get.find();

  final frpc_work_path = FrpcManagerStorage.getRunPath('0.51.3');

  void nwprcs({
    required String frp_token,
    required int proxy_id,
  }) async {
    final process = await Process.start(
      await FrpcManagerStorage.getFilePath('0.51.3'),
      [
        '-u',
        frp_token,
        '-p',
        proxy_id.toString(),
      ],
      workingDirectory: await FrpcManagerStorage.getRunPath('0.51.3'),
    );
    // Process [stdout, stderr]
    process.stdout.forEach((element) {
      final fmt_str = utf8.decode(element).trim();
      if (fmt_str.contains('stopped') || fmt_str.contains('启动失败')) {
        print('[${proxy_id}][FRPC][WARN] ${fmt_str}');
        f_c.appendWarnLog(fmt_str);
        process.kill();
      } else {
        print('[${proxy_id}][FRPC][INFO] ${fmt_str}');
        f_c.appendInfoLog(fmt_str);
      }
    });
    process.stderr.forEach((element) {
      final fmt_str = utf8.decode(element).trim();
      print('[${proxy_id}][FRPC][ERROR] ${fmt_str}');
      f_c.appendErrorLog(fmt_str);
      process.kill();
    });
  }
}
