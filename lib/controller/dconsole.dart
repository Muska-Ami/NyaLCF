import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/util/frpc/ProcessManager.dart';

class ConsoleController extends GetxController {
  var widgets = <DataRow>[].obs;
  var process_list = <Map>[].obs;

  addProcess(p_map) {
    process_list.add(p_map);
    process_list.refresh();
  }

  removeProcess(p_map) {
    process_list.remove(p_map);
    process_list.refresh();
  }

  clearProcess() {
    process_list.clear();
    process_list.refresh();
  }

  load() {
    widgets.value = <DataRow>[];
    process_list.forEach((element) {
      final process = element['process'];
      final proxy_id = element['proxy_id'];

      widgets.add(DataRow(cells: [
        DataCell(Text(process.pid.toString())),
        DataCell(Text(proxy_id.toString())),
        DataCell(
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              FrpcProcessManager().kill(element);
            },
          ),
        ),
      ]));
      widgets.refresh();
    });
  }
}
