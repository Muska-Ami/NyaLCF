import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

/// 控制台 GetX 状态控制器
class ConsoleController extends GetxController {
  var widgets = <DataRow>[].obs;

  /// UI组件列表
  var process_list = <Map>[].obs;

  /// 进程管理列表

  /// 添加进程
  addProcess(p_map) {
    process_list.add(p_map);
    process_list.refresh();
  }

  /// 移除进程
  removeProcess(p_map) {
    process_list.remove(p_map);
    process_list.refresh();
  }

  /// 清空进程
  clearProcess() {
    process_list.clear();
    process_list.refresh();
  }

  /// 加载进程管理信息
  load() {
    widgets.value = <DataRow>[];
    process_list.forEach((element) {
      final process = element['process'];
      final proxy_id = element['proxy_id'];

      /// 添加进程管理信息至UI组件列表
      widgets.add(DataRow(cells: [
        DataCell(Text(process.pid.toString())),

        /// 进程ID
        DataCell(Text(proxy_id.toString())),

        /// 代理ID
        DataCell(
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              /// 杀死进程
              FrpcProcessManager().kill(element);
              load();
            },
          ),
        ),
      ]));
      widgets.refresh();
    });
  }
}
