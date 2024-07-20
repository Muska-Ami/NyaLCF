import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';
import 'package:nyalcf_ui/views/panel/console.dart';
import 'package:nyalcf_core/models/process_model.dart';

/// 控制台 GetX 状态控制器
class ConsoleController extends GetxController {
  /// UI组件列表
  var widgets = <DataRow>[].obs;
  static var processListWidget = <Widget>[].obs;

  /// 进程管理列表
  static var processList = <ProcessModel>[].obs;

  /// 添加进程
  addProcess(ProcessModel process) {
    processList.add(process);
    processList.refresh();
    PanelConsole.buildProcessListWidget();
  }

  /// 移除进程
  removeProcess(ProcessModel process) {
    processList.remove(process);
    processList.refresh();
    PanelConsole.buildProcessListWidget();
  }

  /// 清空进程
  clearProcess() {
    processList.clear();
    processList.refresh();
    load();
    PanelConsole.buildProcessListWidget();
  }

  /// 加载进程管理信息
  load() {
    widgets.value = <DataRow>[];
    for (ProcessModel element in processList) {
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
