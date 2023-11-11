import 'package:flutter/material.dart';
import 'package:nyalcf/ui/model/ToolDialog.dart';

import 'model/AppbarActions.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 首页", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          actions: AppbarActions(context: context).actions(),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            child: Column(
              children: <Widget>[
                const Text(
                  "欢迎使用NyaLCF",
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/login"),
                          child: const Text("登录")),
                      ElevatedButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/register"),
                          child: const Text("注册"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.pink[100],
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return ToolDialog(context: context).build();
                }),
            elevation: 7.0,
            highlightElevation: 14.0,
            mini: false,
            shape: const CircleBorder(),
            isExtended: false,
            child: const Icon(Icons.add),
          );
        }));
  }
}
