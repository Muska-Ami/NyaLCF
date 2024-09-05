import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nyalcf_core_extend/utils/widget/after_layout.dart';
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';

class PanelConsoleFull extends StatelessWidget {
  PanelConsoleFull({super.key});

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
    return Scaffold(
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
        onPressed: () async {
          Get.toNamed('/panel/console');
        },
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
