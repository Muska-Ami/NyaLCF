import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:nyalcf/controller.dart';

import '../model/AppbarActions.dart';

class PanelHome extends StatelessWidget {
  PanelHome({super.key, required this.title});

  final Controller c = Get.find();
  final String title;

  @override
  Widget build(BuildContext context) {
    c.load();

    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 仪表板", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          automaticallyImplyLeading: false,
          actions: AppbarActions(context: context).actions(append: <Widget>[
            Obx(
              () => IconButton(
                onPressed: () => {},
                icon: ImageIcon(
                  Image.network("${c.avatar}").image,
                ),
              ),
            )
          ]),
        ),
        body: ListView(children: [
          Container(
              margin: const EdgeInsets.all(40.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Obx(() => Text(
                          "指挥官 ${c.user}，${c.welcomeText}喵！",
                          style: TextStyle(fontSize: 15),
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.info),
                                title: Text("指挥官信息"),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 15.0, right: 15.0, bottom: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Obx(() => Text("用户名：${c.user}")),
                                    Obx(() => Text("邮箱：${c.email}")),
                                    Obx(() => Text(
                                        "限制速率：${c.inbound / 1024 * 8}Mbps/${c.outbound / 1024 * 8}Mbps")),
                                    //Obx(() => Text(""))
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                        Expanded(
                            child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.announcement),
                                title: Text("公告"),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  child: Text("看什么看，偷懒没写！（")),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ],
                ),
              )),
        ]),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
