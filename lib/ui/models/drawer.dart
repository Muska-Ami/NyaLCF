import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerX {
  const DrawerX({required this.context});

  final BuildContext context;

  Widget drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage('https://api.imlazy.ink/img'),
                    fit: BoxFit.cover),
                color: Colors.pink,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(
                            255, 101, 160, 0.4196078431372549),
                        borderRadius: BorderRadius.circular(50.0)),
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: const Text(
                              '菜单',
                              style: TextStyle(color: Colors.white),
                            ))))
              ])),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('仪表板'),
            onTap: () {
              Get.close(0);
              Get.toNamed('/panel/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('隧道列表'),
            onTap: () {
              Get.close(0);
              Get.toNamed('/panel/proxies');
            },
          ),
          ListTile(
            leading: const Icon(Icons.last_page),
            title: const Text('控制台'),
            onTap: () {
              Get.close(0);
              Get.toNamed('/panel/console');
            },
          )
        ],
      ),
    );
  }
}
