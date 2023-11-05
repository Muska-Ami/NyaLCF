import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text("$title - 登录")),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          child: Column(children: <Widget>[
            const Text(
              "登录到LocyanFrp",
              style: TextStyle(fontSize: 30),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const TextField(
                    decoration: InputDecoration(labelText: "账户名/邮箱"),
                  ),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "密码"),
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
    );
  }
}
