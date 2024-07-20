import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/frpc_controller.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/models/process_model.dart';
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

    ProcessModel? process;
    Process? processInstance;
    try {
      processInstance = await Process.start(
        frpcPath,
        arguments,
        workingDirectory: await _fss.getRunPath(),
      );
      process = ProcessModel(proxyId: proxyId, process: processInstance);
      // procesList.add();
      // pMap['process'] = process;
      // pMap['proxy_id'] = proxyId;
      cctr.addProcess(process);
    } catch (e, st) {
      // 检测是否被拦截
      if (e.toString().contains('包含病毒或潜在的垃圾软件')) {
        Get.dialog(DefenderDialogX().build());
      }
      Logger.error(e, t: st);
    }

    if (process != null && processInstance != null) {
      // Process [stdout, stderr]
      processInstance.stdout.forEach((List<int> element) {
        final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
        final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
        logCommonOut(process!, fmtStr);
      });
      processInstance.stderr.forEach((List<int> element) {
        final String fmtStr = utf8.decode(element).trim();
        Logger.frpcError(proxyId, fmtStr);
        _fCtr.appendErrorLog(fmtStr);
        process!.process.kill();
        cctr.removeProcess(process);
      });
    }

    //print('Process length: ${process_list.length}');
  }

  void logCommonOut(ProcessModel process, String str) {
    if ((str.contains('[W]') ||
            str.contains('stopped') ||
            str.contains('启动失败') ||
            str.contains('无法连接')) &&
        !str.contains('重连失败')) {
      // 启动失败
      Logger.frpcWarn(process.proxyId, str);
      _fCtr.appendWarnLog(str);
      process.process.kill();
      cctr.removeProcess(process);
    } else if (str.contains('[E]') || str.contains('failed')) {
      // Frpc 错误
      Logger.frpcError(process.proxyId, str);
      _fCtr.appendErrorLog(str);
      // 例外
      if (!str.contains(
          'No connection could be made because the target machine actively refused it')) {
        process.process.kill();
        cctr.removeProcess(process);
      }
    } else {
      Logger.frpcInfo(process.proxyId, str);
      _fCtr.appendInfoLog(str);
    }
    final List<Map<String, String>> errorList = [
      {
        'key': '403',
        'info': '403 Forbidden - 当前错误可能由于未完成实名/实人认证，或后端服务器无法连接到验证服务器导致',
      },
      {
        'key': '404',
        'info': '404 Not Found - 当前节点可能已经下架，或 Frpc 配置文件存在问题',
      },
      {
        'key': 'i/o timed out',
        'info': 'i/o timed out - 当前节点状态异常，或当前网络无法连接节点导致',
      },
      {
        'key': 'already exists',
        'info': 'already exists - 当前隧道已在线，无法重复启动',
      },
      {
        'key': 'cannot connect to local service',
        'info':
            'cannot connect to local service - Frpc 无法连接到本地服务，请检查本地服务状态及本地服务端口',
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

  void kill(ProcessModel prs) {
    Logger.info('Killing frpc process, pid: ${prs.process.pid}');
    _fCtr.appendSystemInfoLog('Killing process, pid: ${prs.process.pid}');
    prs.process.kill();
    cctr.removeProcess(prs);

    Logger.debug('Process length: ${ConsoleController.processList.length}');
  }
}
