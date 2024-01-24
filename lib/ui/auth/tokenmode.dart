import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/prefs/TokenModePrefs.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

class TokenModeAuth extends StatefulWidget {
  TokenModeAuth({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _TokenModeAuthState(title: title);
}

class _TokenModeAuthState extends State {
  _TokenModeAuthState({required this.title});

  final String title;

  final tokenController = TextEditingController();

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - TokenMode',
            style: const TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.all(40.0),
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    '请输入Frp Token',
                    style: TextStyle(fontSize: 30),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Frp Token',
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(),
                            ),
                            controller: tokenController,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              TokenModePrefs.setToken(tokenController.text);
                              Get.toNamed('/token_mode/panel');
                            },
                            child: Text('下一步'),
                          ),
                        ),
                        const Text(
                          '使用前请确认Frp Token正确喵，猫猫是不会帮你校验Frp Token有效性哒！',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
