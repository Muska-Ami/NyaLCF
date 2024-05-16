import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/console_controller.dart';
import 'package:nyalcf_core/controllers/frpc_controller.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_ui/models/account_dialog.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/drawer.dart';

class PanelConsoleFull extends StatelessWidget {
  PanelConsoleFull({super.key});

  final UserController uctr = Get.find();
  final FrpcController fctr = Get.find();
  final ConsoleController cctr = Get.find();

  @override
  Widget build(BuildContext context) {
    cctr.load();
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('$title - 仪表板', style: TextStyle(color: Colors.white)),

        //automaticallyImplyLeading: false,
        actions: AppbarActionsX(append: <Widget>[
          IconButton(
            onPressed: () {
              Get.dialog(AccountDialogX(context: context).build());
            },
            icon: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.network(
                    '${uctr.avatar}',
                    width: 35,
                  ),
                )),
          ),
        ], context: context)
            .actions(),
      ),
      drawer: DrawerX(context: context).drawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade900,
            child: Obx(
              () => SizedBox(
                height: MediaQuery.of(context).size.height-55,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: fctr.processOut,
                ),
              )
            ),
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
