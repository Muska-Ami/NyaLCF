import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/controllers/console_controller.dart';
import 'package:nyalcf/controllers/frpc_controller.dart';
import 'package:nyalcf/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf/storages/stores/frpc_storage.dart';
import 'package:nyalcf/utils/logger.dart';

class FrpcProcessManager {
  final fss = FrpcStorage();
  final FrpcController fctr = Get.find();
  final ConsoleController cctr = Get.find();

  void nwprcs({
    required String frpToken,
    required int proxyId,
    required String frpcPath,
  }) async {
    if (Platform.isLinux || Platform.isMacOS) {
      Logger.info('*unix platform, change file permission');
      await fss.setRunPermission();
    }
    final Map<String, dynamic> pMap = <String, dynamic>{};
    List<String> arguments = <String>[];

    final String? confPath =
        await ProxiesConfigurationStorage.getConfigPath(proxyId);
    if (confPath != null) {
      arguments = <String>['-c', confPath];
    } else {
      arguments = <String>[
        '-u',
        frpToken,
        '-p',
        proxyId.toString(),
      ];
    }

    final Process process = await Process.start(
      frpcPath,
      arguments,
      workingDirectory: await fss.getRunPath(),
    );
    pMap['process'] = process;
    pMap['proxy_id'] = proxyId;
    cctr.addProcess(pMap);

    /// Process [stdout, stderr]
    process.stdout.forEach((List<int> element) {
      final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
      final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
      if ((fmtStr.contains('[W]') ||
          fmtStr.contains('stopped') ||
          fmtStr.contains('启动失败') ||
          fmtStr.contains('无法连接')) &&
          !fmtStr.contains('重连失败')) {
        Logger.frpcWarn('[$proxyId] $fmtStr');
        fctr.appendWarnLog(fmtStr);
        process.kill();
        cctr.removeProcess(pMap);
      } else if (fmtStr.contains('[E]') ||
          fmtStr.contains('failed') ||
          (fmtStr.contains('err') && !fmtStr.contains('terr'))) {
        Logger.frpcError('[$proxyId] $fmtStr');
        if (!fmtStr.contains(
            'No connection could be made because the target machine actively refused it')) {
          process.kill();
        }
        fctr.appendErrorLog(fmtStr);
        cctr.removeProcess(pMap);
      } else {
        Logger.frpcInfo('[$proxyId] $fmtStr');
        fctr.appendInfoLog(fmtStr);
      }
    });
    process.stderr.forEach((List<int> element) {
      final String fmtStr = utf8.decode(element).trim();
      Logger.frpcError('[$proxyId] $fmtStr');
      fctr.appendErrorLog(fmtStr);
      process.kill();
      cctr.removeProcess(pMap);
    });

    //print('Process length: ${process_list.length}');
  }

  void killAll() {
    Logger.info('Killing all process');
    Logger.debug('Process length: ${ConsoleController.processList.length}');
    fctr.appendSystemInfoLog('Killing all process...');
    try {
      var allList = [];
      allList.addAll(ConsoleController.processList);
      for (var element in allList) {
        kill(element);
      }
      cctr.clearProcess();
    } catch (e) {
      fctr.appendSystemErrorLog('Killing all process error: $e');
      Logger.error(e);
    }
    Logger.info('All process killed');
    fctr.appendSystemInfoLog('All process killed');
  }

  void kill(prs) {
    Logger.info('Killing frpc process, pid: ${prs['process'].pid}');
    fctr.appendSystemInfoLog('Killing process, pid: ${prs['process'].pid}');
    prs['process'].kill();
    cctr.removeProcess(prs);

    Logger.debug('Process length: ${ConsoleController.processList.length}');
  }
}
