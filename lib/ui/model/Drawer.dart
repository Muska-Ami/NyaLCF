import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerX {
  const DrawerX({required this.context});

  final BuildContext context;

  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://api.imlazy.ink/img"),
                    fit: BoxFit.cover),
                color: Colors.pink,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 101, 160, 0.4196078431372549),
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Center(
                        child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '菜单',
                              style: TextStyle(color: Colors.white),
                            ))))
              ])),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: const Text('仪表板'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/panel/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: const Text('隧道列表'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/panel/proxies');
            },
          ),
          ListTile(
            leading: Icon(Icons.last_page),
            title: const Text('控制台'),
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('/panel/console');
            },
          )
        ],
      ),
    );
  }
}
