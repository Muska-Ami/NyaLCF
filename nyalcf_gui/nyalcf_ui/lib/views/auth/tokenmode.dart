// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_mode_prefs.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class TokenModeAuth extends StatefulWidget {
  const TokenModeAuth({super.key});

  @override
  State<StatefulWidget> createState() => _TokenModeAuthState();
}

class _TokenModeAuthState extends State {
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
        title: const Text('$title - TokenMode'),
        actions: AppbarActions(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
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
                    '请输入 Frp Token',
                    style: TextStyle(fontSize: 30),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(6.0),
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
                              if (tokenController.text != '') {
                                TokenModePrefs.setToken(tokenController.text);
                                Get.toNamed('/token_mode/panel');
                              } else {
                                Get.snackbar(
                                  '无效数据',
                                  '请输入 Frp Token',
                                  snackPosition: SnackPosition.BOTTOM,
                                  animationDuration:
                                      const Duration(milliseconds: 300),
                                );
                              }
                            },
                            child: const Text('下一步'),
                          ),
                        ),
                        const Text(
                          '使用前请确认 Frp Token 正确喵，猫猫是不会帮你校验Frp Token有效性哒！',
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
      floatingActionButton: floatingActionButton(),
    );
  }
}
