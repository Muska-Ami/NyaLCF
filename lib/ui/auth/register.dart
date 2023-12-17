import 'package:flutter/material.dart';

import '../model/AppbarActions.dart';
import '../model/FloatingActionButton.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _RegisterState(title: title);
}

class _RegisterState extends State<Register> {
  _RegisterState({required this.title});

  final title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text("$title - 注册", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          actions: AppbarActions(context: context).actions(),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Column(children: <Widget>[
              const Text(
                "注册LoCyanFrp账户",
                style: TextStyle(fontSize: 30),
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(6.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "用户名",
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "密码",
                          icon: Icon(Icons.key),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "重复密码",
                          icon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(6.0),
                      child: TextFormField(
                        validator: (value) {
                          RegExp reg = RegExp(
                              '^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}\$');
                          if (reg.hasMatch(value!)) {
                            return "无效的邮箱";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "邮箱",
                          icon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(8.0),
                        child: const ElevatedButton(
                            onPressed: null, child: Text("注册"))),
                  ],
                ),
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}
