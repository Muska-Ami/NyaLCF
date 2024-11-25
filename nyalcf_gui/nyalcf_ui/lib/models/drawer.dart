// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

Widget drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: NetworkImage('https://api.imlazy.ink/img'),
                  fit: BoxFit.cover),
              color: Get.theme.primaryColor,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              DecoratedBox(
                  decoration: BoxDecoration(
                      color: Get.theme.splashColor,
                      borderRadius: BorderRadius.circular(50.0)),
                  child: Center(
                      child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: const Text(
                            '菜单',
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
