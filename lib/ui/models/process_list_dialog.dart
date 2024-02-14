import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/console_controller.dart';

class ProcessListDialogX {
  ProcessListDialogX({required this.context});

  final BuildContext context;
  final ConsoleController cctr = Get.find();

  Widget build() {
    return SimpleDialog(
      title: const Text('Frpc进程列表'),
      children: <Widget>[
        Obx(
          () => DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('进程PID')),
              DataColumn(label: Text('隧道ID')),
              DataColumn(label: Text('操作')),
            ],
            rows: cctr.widgets.value,
          ),
        ),
      ],
    );
  }
}
