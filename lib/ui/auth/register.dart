import 'package:flutter/material.dart';

import '../model/ToolDialog.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _RegisterState(title: title);
}

class _RegisterState extends State<Register> {
  _RegisterState({required this.title});
  final _formKey = GlobalKey<_RegisterState>();
  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 注册", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(children: <Widget>[
              const Text(
                "注册LocyanFrp账户",
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
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "重复密码"),
                    ),
                    TextFormField(
                      validator: (value) {
                        RegExp reg = RegExp(
                            '^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}\$');
                        if (reg.hasMatch(value!)) {
                          return "无效的邮箱";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "邮箱"),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20.0),
                        child: const ElevatedButton(
                            onPressed: null, child: Text("注册"))),
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
