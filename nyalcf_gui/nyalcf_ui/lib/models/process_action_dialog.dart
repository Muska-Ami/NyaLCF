// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/process_model.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';

final ConsoleController _cCtr = Get.find();

Widget processActionDialog(ProcessModel process) {
  return SimpleDialog(
    title: Text('隧道 ${process.proxyId}'),
    children: <Widget>[
      SimpleDialogOption(
        child: const ListTile(
          leading: Icon(Icons.close),
          title: Text('关闭进程'),
        ),
        onPressed: () async {
          /// 杀死进程
          FrpcProcessManager().kill(process);
          _cCtr.load();
          Get.close(0);
        },
      ),
    ],
  );
}
