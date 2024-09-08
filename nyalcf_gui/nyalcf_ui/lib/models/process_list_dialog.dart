// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';

final ConsoleController _cCtr = Get.find();

Widget processListDialog(BuildContext context) {
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
          // ignore: invalid_use_of_protected_member
          rows: _cCtr.widgets.value,
        ),
      ),
    ],
  );
}
