// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class ConsoleFullPanelUI extends StatelessWidget {
  ConsoleFullPanelUI({super.key});

  final UserController _uCtr = Get.find();
  final ConsoleController _cCtr = Get.find();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    _cCtr.load();
    _cCtr.processOut.listen((data) {
      if (_cCtr.autoScroll.value && scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 200), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    });
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
      drawer: drawer(context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade900,
            child: Obx(() => SizedBox(
                  height: MediaQuery.of(context).size.height - 56,
                  child: AfterLayout(
                    callback: (RenderAfterLayout ral) => scrollController
                        .jumpTo(scrollController.position.maxScrollExtent),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(10),
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: _cCtr.processOut,
                    ),
                  ),
                )),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => Get.back(),
        elevation: 7.0,
        highlightElevation: 14.0,
        mini: false,
        shape: const CircleBorder(),
        isExtended: false,
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
