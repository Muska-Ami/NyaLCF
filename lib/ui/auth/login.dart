import 'package:flutter/material.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';

import '../model/ToolDialog.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _LoginState(title: title);
}

class _LoginState extends State<Login> {
  _LoginState({required this.title});
  final _formKey = GlobalKey<_LoginState>();
  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 登录", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          actions: AppbarActions(context: context).actions(),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(children: <Widget>[
              const Text(
                "登录到LocyanFrp",
                style: TextStyle(fontSize: 30),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: "账户名/邮箱"),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "密码"),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20.0),
                        child: const ElevatedButton(
                            onPressed: null, child: Text("登录"))),
                  ],
                ),
              ),
            ]),
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
