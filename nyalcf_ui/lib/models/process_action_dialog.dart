import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/console_controller.dart';
import 'package:nyalcf_core/utils/frpc/process_manager.dart';

class ProcessActionDialogX {
  ProcessActionDialogX({
    required this.process,
  });

  final Map<String, dynamic> process;
  final ConsoleController cctr = Get.find();

  Widget build() {
    return SimpleDialog(
      title: Text('隧道 ${process['proxy_id']}'),
      children: <Widget>[
        SimpleDialogOption(
          child: const ListTile(
            leading: Icon(Icons.close),
            title: Text('关闭进程'),
          ),
          onPressed: () async {
            /// 杀死进程
            FrpcProcessManager().kill(process);
            cctr.load();
            Get.close(0);
          },
        ),
      ],
    );
  }
}
