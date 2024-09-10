// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/proxies_configuration_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';

class PanelProxiesConfiguration extends StatelessWidget {
  PanelProxiesConfiguration({super.key});

  final UserController _uCtr = Get.find();
  final ProxiesConfigurationController _pcCtr =
      Get.put(ProxiesConfigurationController());

  @override
  Widget build(BuildContext context) {
    return AfterLayout(
      callback: (RenderAfterLayout ral) {
        _pcCtr.load();
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('$title - 仪表板', style: TextStyle(color: Colors.white)),

          //automaticallyImplyLeading: false,
          actions: AppbarActions(append: <Widget>[
            IconButton(
              onPressed: () {
                Get.dialog(accountDialog(context));
              },
              icon: Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: Image.network(
                      '${_uCtr.avatar}',
                      width: 35,
                    ),
                  )),
            ),
          ], context: context)
              .actions(),
        ),
        body: Obx(() => _pcCtr.configListWidget.value),
        floatingActionButton: FloatingActionButton(
          onPressed: () async => Get.back(),
          elevation: 7.0,
          highlightElevation: 14.0,
          mini: false,
          shape: const CircleBorder(),
          isExtended: false,
          child: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
