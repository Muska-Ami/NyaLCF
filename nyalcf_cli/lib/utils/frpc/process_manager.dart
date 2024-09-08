// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/models/process_model.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProcessManager {
  static final List<ProcessModel> processList = [];

  /// 添加进程
  static void addProcess(ProcessModel process) {
    processList.add(process);
  }

  /// 添加进程
  static void removeProcess(ProcessModel process) {
    processList.remove(process);
  }

  /// 运行一个新 Frpc 进程
  static Future<ProcessModel> newProcess({
    required String frpcPath,
    required String runPath,
    required String frpToken,
    required int proxyId,
  }) async {
    final ProcessModel process;

    final processInstance = await Process.start(
      frpcPath,
      [
        '-u',
        frpToken,
        '-p',
        proxyId.toString(),
      ],
      workingDirectory: runPath,
    );

    process = ProcessModel(proxyId: proxyId, process: processInstance);

    processInstance.stdout.forEach((List<int> element) {
      final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
      final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
      Logger.frpcInfo(proxyId, fmtStr);
    });
    processInstance.stderr.forEach((List<int> element) {
      final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
      final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
      Logger.frpcError(proxyId, fmtStr);
    });

    return process;
  }
}
