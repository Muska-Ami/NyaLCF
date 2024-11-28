// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/process_model.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/frpc_controller.dart';

/// 控制台 GetX 状态控制器
class ConsoleController extends GetxController {
  final _lcs = LauncherConfigurationStorage();

  /// UI组件列表
  var widgets = <DataRow>[].obs;

  /// <Rx>进程列表
  static var processListWidget = <Widget>[].obs;

  /// <Rx>控制台自动滚动
  var autoScroll = true.obs;

  /// 输出提示开关
  bool get kindTip => _lcs.getConsoleKindTip();

  /// 过滤后的输出文本
  RxList<SelectableText> processOut = <SelectableText>[
    const SelectableText(
      '[SYSTEM] Welcome to frpc console.',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w200,
        fontFamily: 'Droid Sans Mono',
      ),
    )
  ].obs;

  /// 追加信息日志
  /// [element] 日志内容
  void appendInfoLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加信息日志文本
    processOut.add(
      SelectableText(
        '[FRPC][INFO] $element',
        style: const TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加警告日志
  /// [element] 日志内容
  void appendWarnLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加警告日志文本
    processOut.add(
      SelectableText(
        '[FRPC][WARN] $element',
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加错误日志
  /// [element] 日志内容
  void appendErrorLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加错误日志文本
    processOut.add(
      SelectableText(
        '[FRPC][ERROR] $element',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加系统信息日志
  /// [element] 日志内容
  void appendSystemInfoLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加警告日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][INFO] $element',
        style: TextStyle(
          color: Colors.tealAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加系统警告日志
  /// [element] 日志内容
  void appendSystemWarnLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加信息日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][WARN] $element',
        style: TextStyle(
          color: Colors.orangeAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加系统错误日志
  /// [element] 日志内容
  void appendSystemErrorLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加错误日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][ERROR] $element',
        style: TextStyle(
          color: Colors.redAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 加载进程管理信息
  load() {
    widgets.value = <DataRow>[];
    for (ProcessModel element in FrpcController.processList) {
      final Process process = element.process;
      final int proxyId = element.proxyId;

      /// 添加进程管理信息至UI组件列表
      widgets.add(DataRow(cells: <DataCell>[
        DataCell(Text(process.pid.toString())),

        /// 进程ID
        DataCell(Text(proxyId.toString())),

        /// 代理ID
        DataCell(
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              /// 杀死进程
              FrpcProcessManager().kill(element);
              load();
            },
          ),
        ),
      ]));
      widgets.refresh();
    }
  }
}
