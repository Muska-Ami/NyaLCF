import 'package:flutter/material.dart';
import 'package:nyalcf/ui/model/floatingActionButton.dart';

import '../model/AppbarActions.dart';

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
                  "Panel Home",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
