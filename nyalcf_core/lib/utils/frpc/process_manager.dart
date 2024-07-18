import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:nyalcf_core/controllers/console_controller.dart';
import 'package:nyalcf_core/controllers/frpc_controller.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_ui/models/defender_dialog.dart';

class FrpcProcessManager {
  final _fss = FrpcStorage();
  final FrpcController _fCtr = Get.find();
  final ConsoleController cctr = Get.find();

  void nwprcs({
    required String frpToken,
    required int proxyId,
    required String frpcPath,
  }) async {
    if (Platform.isLinux || Platform.isMacOS) {
      Logger.info('*unix platform, change file permission');
      await _fss.setRunPermission();
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

    Process? process;
    try {
      process = await Process.start(
        frpcPath,
        arguments,
        workingDirectory: await _fss.getRunPath(),
      );
      pMap['process'] = process;
      pMap['proxy_id'] = proxyId;
      cctr.addProcess(pMap);
    } catch (e, st) {
      if (e.toString().contains('包含病毒或潜在的垃圾软件')) {
        Get.dialog(DefenderDialogX().build());
      }
      Logger.error(e, t: st);
    }

    if (process != null) {
      /// Process [stdout, stderr]
      process.stdout.forEach((List<int> element) {
        final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
        final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
        logCommonOut(pMap, fmtStr, proxyId);
      });
    }
    process!.stderr.forEach((List<int> element) {
      final String fmtStr = utf8.decode(element).trim();
      Logger.frpcError(proxyId, fmtStr);
      _fCtr.appendErrorLog(fmtStr);
      process!.kill();
      cctr.removeProcess(pMap);
    });

    //print('Process length: ${process_list.length}');
  }

  void logCommonOut(pMap, String str, proxyId) {
    if ((str.contains('[W]') ||
            str.contains('stopped') ||
            str.contains('启动失败') ||
            str.contains('无法连接')) &&
        !str.contains('重连失败')) {
      Logger.frpcWarn(proxyId, str);
      _fCtr.appendWarnLog(str);
      pMap['process']!.kill();
      cctr.removeProcess(pMap);
    } else if (str.contains('[E]') || str.contains('failed')) {
      Logger.frpcError(proxyId, str);
      _fCtr.appendErrorLog(str);
      if (!str.contains(
          'No connection could be made because the target machine actively refused it')) {
        pMap['process']!.kill();
        cctr.removeProcess(pMap);
      }
    } else {
      Logger.frpcInfo(proxyId, str);
      _fCtr.appendInfoLog(str);
    }
    final List<Map<String, String>> errorList = [
      {
        'key': '403',
        'info': '403 Forbidden - 当前错误可能由于未完成实名/实人认证，或后端服务器无法连接到验证服务器导致'
      },
      {
        'key': '404',
        'info': '404 Not Found - 当前节点可能已经下架，或 Frpc 配置文件存在问题'
      },
      {
        'key': 'i/o timed out',
        'info': 'i/o timed out - 当前节点状态异常，或当前网络无法连接节点导致'
      },
      {
        'key': 'already exists',
        'info': 'already exists - 当前隧道已在线，无法重复启动'
      },
      {
        'key': 'cannot connect to local service',
        'info': 'cannot connect to local service - Frpc 无法连接到本地服务，请检查本地服务状态及本地服务端口'
      },
    ];
    for (Map<String, String> error in errorList) {
      if (str.contains(error['key']!)) {
        _fCtr.appendSystemInfoLog('提示：${error['info']}');
      }
    }
  }

  void killAll() {
    Logger.info('Killing all process');
    Logger.debug('Process length: ${ConsoleController.processList.length}');
    _fCtr.appendSystemInfoLog('Killing all process...');
    try {
      var allList = [];
      allList.addAll(ConsoleController.processList);
      for (var element in allList) {
        kill(element);
      }
      cctr.clearProcess();
    } catch (e, st) {
      _fCtr.appendSystemErrorLog('Killing all process error: $e');
      Logger.error(e, t: st);
    }
    Logger.info('All process killed');
    _fCtr.appendSystemInfoLog('All process killed');
  }

  void kill(prs) {
    Logger.info('Killing frpc process, pid: ${prs['process'].pid}');
    _fCtr.appendSystemInfoLog('Killing process, pid: ${prs['process'].pid}');
    prs['process'].kill();
    cctr.removeProcess(prs);

    Logger.debug('Process length: ${ConsoleController.processList.length}');
  }
}
