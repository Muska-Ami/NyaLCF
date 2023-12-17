import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller.dart';

class AppbarActions {
  AppbarActions({required this.context});

  final Controller c = Get.find();

  final context;

  List<Widget> list() {
    return <Widget>[
      IconButton(
        onPressed: () => {appWindow.minimize()},
        icon: Icon(Icons.horizontal_rule),
        color: Colors.white,
      ),
      IconButton(
        onPressed: () => {_closeAlertDialog()},
        icon: Icon(Icons.close),
        color: Colors.white,
      ),
    ];
  }

  List<Widget> actions({List<Widget>? append}) {
    List<Widget> l = <Widget>[];
    l.addAll(append ?? []);
    l.addAll(list());
    return l;
  }

  _closeAlertDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('关闭NyaLCF'),
            content: Text('确定要关闭NyaLCF吗'),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    '取消',
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  }),
              TextButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });

    if (result) appWindow.close();
  }
}
