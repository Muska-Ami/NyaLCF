// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/proxies_configuration_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class ProxiesConfigurationPanelUI extends StatelessWidget {
  ProxiesConfigurationPanelUI({super.key});

  final UserController _uCtr = Get.find();
  final ProxiesConfigurationController _pcCtr =
      Get.put(ProxiesConfigurationController());

  @override
  Widget build(BuildContext context) {
    return NyaScaffold(
      name: '仪表板',
      appbarActions: AppbarActions(
        append: <Widget>[
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
        ],
        context: context,
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
      afterLayout: (RenderAfterLayout ral) => _pcCtr.load(),
    );
  }
}
