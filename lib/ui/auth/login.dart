import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/dio/auth/login.dart';
import 'package:nyalcf/model/User.dart';
import 'package:nyalcf/prefs/UserInfoPrefs.dart';
import 'package:nyalcf/ui/model/AppbarActions.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _LoginState(title: title);
}

class _LoginState extends State<Login> {
  _LoginState({required this.title});

  final String title;

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
        title: Text('$title - 登录', style: const TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: Column(children: <Widget>[
            const Text(
              '登录到LoCyanFrp',
              style: TextStyle(fontSize: 30),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(6.0),
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
                    margin: EdgeInsets.all(6.0),
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
                          onPressed: () => {_login()}, child: Text('登录'))),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }

  _login() async {
    if (userController.text == '') {
      Get.snackbar(
        '无效数据',
        '请输入用户名',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 300),
      );
    } else if (passwordController.text == '') {
      Get.snackbar(
        '无效数据',
        '请输入密码',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        '登录中',
        '正在请求...',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: Duration(milliseconds: 300),
      );
      final res = await LoginDio()
          .requestLogin(userController.text, passwordController.text);
      if (res is User) {
        //UserInfoCache.info = res;
        //print(UserInfoCache.info);
        await UserInfoPrefs.setInfo(res);
        UserInfoPrefs.saveToFile();
        Get.snackbar(
          '登录成功',
          '欢迎您，指挥官 ${res.user}',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: Duration(milliseconds: 300),
        );
        Get.toNamed('/panel/home');
      } else {
        Get.snackbar(
          '登录失败',
          res.toString(),
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: Duration(milliseconds: 300),
        );
      }
    }
  }
}
