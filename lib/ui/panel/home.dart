import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';
import 'package:nyalcf/util/cache/InfoCache.dart';
import 'package:nyalcf/util/model/User.dart';

import '../model/AppbarActions.dart';

class PanelHome extends StatelessWidget {
  const PanelHome({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {

    // GetX
    final Controller c = Get.put(Controller());
    c.load();

    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 仪表板", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          automaticallyImplyLeading: false,
          actions: AppbarActions(context: context).actions(append: <Widget>[
            IconButton(
              onPressed: () => {},
              icon: ImageIcon(Image.network("").image),
              color: Colors.white,
            ),
          ]),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                Obx(() => Text(
                    "${c.user}",
                    style: TextStyle(fontSize: 30),
                ))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}

class Controller extends GetxController {
  var user   = "".obs;
  var email  = "".obs;
  var token  = "".obs;
  var avatar = "".obs;

  load() async {
    User userinfo = await InfoCache.getInfo();
    user = userinfo.user.obs;
    email = userinfo.email.obs;
    token = userinfo.token.obs;
    avatar = userinfo.avatar.obs;
  }
}
