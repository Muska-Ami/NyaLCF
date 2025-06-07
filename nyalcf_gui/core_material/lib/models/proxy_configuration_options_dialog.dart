// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/proxies_configuration_controller.dart';
import 'package:nyalcf_ui/models/frpc_configuration_editor_dialog.dart';

final ProxiesConfigurationController _pcCtr =
    Get.put(ProxiesConfigurationController());

Widget proxyConfigurationOptionsDialog(BuildContext context, int proxyId) {
  return SimpleDialog(
    title: Text('隧道 $proxyId'),
    children: <Widget>[
      SimpleDialogOption(
        child: const ListTile(
          leading: Icon(Icons.delete),
          title: Text('删除配置'),
        ),
        onPressed: () async {
          await ProxiesConfigurationStorage.deleteConfig(proxyId);
          _pcCtr.load();
          Get.close(0);
        },
      ),
      SimpleDialogOption(
        child: const ListTile(
          leading: Icon(Icons.edit),
          title: Text('编辑'),
        ),
        onPressed: () async {
          final file =
              File((await ProxiesConfigurationStorage.getConfigPath(proxyId))!);
          await Get.dialog(frpcConfigurationEditorDialog(
            context,
            await file.readAsString(),
            proxyId: proxyId,
          ));
          Get.close(0);
        },
      ),
    ],
  );
}
