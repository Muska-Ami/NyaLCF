import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

class ConsoleController extends GetxController {

  final process_list = FrpcProcessManager.process_list;

  var widgets = <DataRow>[].obs;

  load() {
    widgets.value = <DataRow>[];
    process_list.forEach((element) {
      final process = element['process'];
      final proxy_id = element['proxy_id'];

      widgets.add(DataRow(cells: [
        DataCell(Text(process.pid.toString())),
        DataCell(Text(proxy_id.toString())),
      ]));
      widgets.refresh();
    });
  }
}