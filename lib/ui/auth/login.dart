import 'package:flutter/material.dart';
import 'package:nyalcf/dio/auth/loginReq.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';

import '../model/floatingActionButton.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _LoginState(title: title);
}

class _LoginState extends State<Login> {
  _LoginState({required this.title});

  final title;

  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: "账户名/邮箱"),
                      controller: userController,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "密码"),
                      controller: passwordController,
                    ),
                    Container(
                        margin: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                            onPressed: () => {_login()}, child: Text("登录"))),
                  ],
                ),
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }

  _login() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('正在登录...'),
    ));
    if (await LoginReq()
        .requestLogin(userController.text, passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登录成功'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('登录失败'),
      ));
    }
  }
}
