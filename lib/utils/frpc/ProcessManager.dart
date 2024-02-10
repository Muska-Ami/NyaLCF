import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/controllers/consoleController.dart';
import 'package:nyalcf/controllers/frpcController.dart';
import 'package:nyalcf/storages/configurations/ProxiesConfigurationStorage.dart';
import 'package:nyalcf/storages/stories/FrpcStoryStorage.dart';
import 'package:nyalcf/utils/Logger.dart';

class FrpcProcessManager {
  final FrpcController f_c = Get.find();
  final ConsoleController c_c = Get.find();

  final frpc_work_path = FrpcStoryStorage.getRunPath();

  void nwprcs({
    required String frp_token,
    required int proxy_id,
    String? frpc_path = null,
  }) async {
    if (!Platform.isWindows) {
      Logger.info('*nix platform, change file permission');
      await FrpcStoryStorage.setRunPermission();
    }
    final Map<String, dynamic> p_map = Map();
    List<String> arguments = [];

    final conf_path = await ProxiesConfigurationStorage.getConfigPath(proxy_id);
    if (conf_path != null) {
      arguments = ['-c', conf_path];
    } else {
      arguments = [
        '-u',
        frp_token,
        '-p',
        proxy_id.toString(),
      ];
    }

    final process = await Process.start(
      frpc_path ?? await FrpcStoryStorage.getFilePath(),
      arguments,
      workingDirectory: await FrpcStoryStorage.getRunPath(),
    );
    p_map['process'] = process;
    p_map['proxy_id'] = proxy_id;
    c_c.addProcess(p_map);

    /// Process [stdout, stderr]
    process.stdout.forEach((element) {
      final regex = RegExp(r'\x1B\[[0-9;]*[mK]');
      final fmt_str = utf8.decode(element).trim().replaceAll(regex, '');
      if (fmt_str.contains('stopped') || fmt_str.contains('启动失败')) {
        Logger.frpc_warn('[${proxy_id}] ${fmt_str}');
        f_c.appendWarnLog(fmt_str);
        process.kill();
        c_c.removeProcess(p_map);
      } else if (fmt_str.contains('failed') || fmt_str.contains('err')) {
        Logger.frpc_error('[${proxy_id}] ${fmt_str}');
        f_c.appendErrorLog(fmt_str);
        process.kill();
        c_c.removeProcess(p_map);
      } else {
        Logger.frpc_info('[${proxy_id}] ${fmt_str}');
        f_c.appendInfoLog(fmt_str);
      }
    });
    process.stderr.forEach((element) {
      final fmt_str = utf8.decode(element).trim();
      Logger.frpc_error('[${proxy_id}] ${fmt_str}');
      f_c.appendErrorLog(fmt_str);
      process.kill();
      c_c.removeProcess(p_map);
    });

    //print('Process length: ${process_list.length}');
  }

  void killAll() {
    Logger.info('Killing all process');
    Logger.debug('Process length: ${c_c.process_list.length}');
    f_c.appendInfoLog('[SYSTEM][INFO] Killing all process...');
    c_c.process_list.forEach((element) {
      kill(element);
    });
    c_c.clearProcess();
    Logger.info('All process killed');
    f_c.appendInfoLog('[SYSTEM][INFO] All process killed');
  }

  void kill(prs) {
    Logger.info('Killing frpc process, pid: ${prs['process'].pid}');
    f_c.appendInfoLog(
        '[SYSTEM][INFO] Killing process, pid: ${prs['process'].pid}');
    prs['process'].kill();
    c_c.removeProcess(prs);

    Logger.debug('Process length: ${c_c.process_list.length}');
  }
}