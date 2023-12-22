import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/frpc.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/ui/model/AccountDialog.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/Drawer.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:url_launcher/url_launcher.dart';

class PanelConsole extends StatelessWidget {
  PanelConsole({super.key, required this.title});

  final UserController c = Get.find();
  final FrpcController f_c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('$title - 仪表板', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          //automaticallyImplyLeading: false,
          actions: AppbarActionsX(append: <Widget>[
            Obx(() => IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return AccountDialogX(context: context).build();
                      });
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Image.network(
                    '${c.avatar}',
                    width: 35,
                  ),
                ))),
          ], context: context)
              .actions(),
        ),
        drawer: DrawerX(context: context).drawer(),
        body: Center(
          child: ListView(
            children: [
              Obx(
                () => Card(
                  margin: EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: Checkbox.width,
                    height: 340.0,
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: ListView(
                        children: f_c.process_out,
                      ),
                    ),
                  ),
                ),
              ),
              Text('这里还是只读视图，不过你可以为这里贡献一下ww~'),
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse('https://github.com/Muska-Ami/NyaLCF'));
                },
                child: SelectableText('https://github.com/Muska-Ami/NyaLCF'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
