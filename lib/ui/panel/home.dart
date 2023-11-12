import 'package:flutter/material.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

import '../model/AppbarActions.dart';

class PanelHome extends StatelessWidget {
  const PanelHome({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "Panel Home",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }

/*
  String _avatarUrl() {
    final info = UserInfoCache.info;
    if (info != null) {
      return UserInfoCache.info!.Avatar;
    } else {
      print("error: userInfo not found");
      return "";
    }
  }
  */
}
