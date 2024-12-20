// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/auth/auth.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
        title: const Text('$title - 登录'),
        actions: AppbarActions(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: Column(children: <Widget>[
            const Text(
              '登录到 LoCyanFrp',
              style: TextStyle(fontSize: 30),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      controller: userController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '密码',
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _login(),
                      child: const Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: floatingActionButton(),
    );
  }

  void _login() async {
    loading.value = true;
    if (userController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        '无效数据',
        '请输入用户名或密码',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      return;
    }

    Get.snackbar(
      '登录中',
      '正在请求...',
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 300),
    );
    final res = await LoginAuth.requestLogin(
        userController.text, passwordController.text);
    if (res.status) {
      res as LoginSuccessResponse;
      await UserInfoPrefs.setInfo(res.userInfo);
      UserInfoPrefs.saveToFile();
      Get.snackbar(
        '登录成功',
        '欢迎您，指挥官 ${res.userInfo.user}',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      Get.toNamed('/panel/home');
    } else {
      Get.snackbar(
        '登录失败',
        res.message,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
    loading.value = false;
  }
}
