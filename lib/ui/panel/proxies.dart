import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/proxies.dart';
import 'package:nyalcf/controller/user.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/Drawer.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

class PanelProxies extends StatelessWidget {
  PanelProxies({required this.title});

  final UserController c = Get.find();
  final p_c = Get.put(ProxiesController());
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 仪表板", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          //automaticallyImplyLeading: false,
          actions: AppbarActions(context: context).actions(append: <Widget>[
            Obx(() => ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.network(
                  "${c.avatar}",
                  width: 35,
                )))
          ]),
        ),
        drawer: DrawerX(context: context).drawer(),
        body: ListView(children: [
          Obx(() => DataTable(columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text("ID"))),
                DataColumn(label: Expanded(child: Text("节点"))),
                DataColumn(label: Expanded(child: Text("端口"))),
                DataColumn(label: Expanded(child: Text("操作")))
              ], rows: p_c.proxiesListWidgets))
        ]),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
