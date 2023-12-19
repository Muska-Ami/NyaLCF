import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/Drawer.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:url_launcher/url_launcher.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key, required this.title});

  final UserController c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 仪表板", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          //automaticallyImplyLeading: false,
          actions: AppbarActionsX(append: <Widget>[
            Obx(() => ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.network(
                  "${c.avatar}",
                  width: 35,
                )))
          ], context: context)
              .actions(),
        ),
        drawer: DrawerX(context: context).drawer(),
        body: Center(
          child: ListView(children: [
            Text("这里还什么都没有，不过你可以为这里贡献一下ww~"),
            ElevatedButton(
              onPressed: () {
                launchUrl(Uri.parse("https://github.com/Muska-Ami/NyaLCF"));
              },
              child: SelectableText("https://github.com/Muska-Ami/NyaLCF"),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
