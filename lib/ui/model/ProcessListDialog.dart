import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dconsole.dart';

class ProcessListDialogX {
  ProcessListDialogX({required this.context});

  final context;
  final ConsoleController c_c = Get.find();

  Widget build() {
    return SimpleDialog(
          title: const Text('Frpc进程列表'),
          children: <Widget>[
            Obx(
              () => DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text('进程PID')),
                  DataColumn(label: Text('隧道ID')),
                  DataColumn(label: Text('操作')),
                ],
                rows: c_c.widgets.value,
              ),
            ),
          ],
        );
  }
}
