import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/controller/dconsole.dart';
import 'package:nyalcf/controller/frpc.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';

class FrpcProcessManager {
  final FrpcController f_c = Get.find();
  final ConsoleController c_c = Get.find();

  final frpc_work_path = FrpcManagerStorage.getRunPath('0.51.3');

  void nwprcs({
    required String frp_token,
    required int proxy_id,
  }) async {
    final Map<String, dynamic> p_map = Map();
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
    p_map['process'] = process;
    p_map['proxy_id'] = proxy_id;
    c_c.addProcess(p_map);

    /// Process [stdout, stderr]
    process.stdout.forEach((element) {
      final fmt_str = utf8.decode(element).trim();
      if (fmt_str.contains('stopped') || fmt_str.contains('启动失败')) {
        print('[${proxy_id}][FRPC][WARN] ${fmt_str}');
        f_c.appendWarnLog(fmt_str);
        process.kill();
        c_c.removeProcess(p_map);
      } else {
        print('[${proxy_id}][FRPC][INFO] ${fmt_str}');
        f_c.appendInfoLog(fmt_str);
      }

      //print('Process length: ${process_list.length}');
    });
    process.stderr.forEach((element) {
      final fmt_str = utf8.decode(element).trim();
      print('[${proxy_id}][FRPC][ERROR] ${fmt_str}');
      f_c.appendErrorLog(fmt_str);
      process.kill();
      c_c.removeProcess(p_map);
    });

    //print('Process length: ${process_list.length}');
  }

  void killAll() {
    print('Killing all process');
    print('Process length: ${c_c.process_list.length}');
    f_c.appendInfoLog('[SYSTEM][INFO] Killing all process...');
    c_c.process_list.forEach((element) {
      print('Killing frpc process, pid: ${element['process'].pid}');
      f_c.appendInfoLog(
          '[SYSTEM][INFO] Killing process, pid: ${element['process'].pid}');
      element['process'].kill();
    });
    c_c.clearProcess();

    print('Process length: ${c_c.process_list.length}');
  }

  void kill(prs) {
    print('Killing frpc process, pid: ${prs['process'].pid}');
    f_c.appendInfoLog(
        '[SYSTEM][INFO] Killing process, pid: ${prs['process'].pid}');
    prs['process'].kill();
    c_c.removeProcess(prs);

    print('Process length: ${c_c.process_list.length}');
  }
}
