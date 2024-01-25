import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/dio/auth/loginAuth.dart';
import 'package:nyalcf/dio/auth/registerAuth.dart';
import 'package:nyalcf/model/UserInfoModel.dart';
import 'package:nyalcf/prefs/UserInfoPrefs.dart';

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

  final String title;

  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final verifyController = TextEditingController();
  final qqController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    verifyController.dispose();
    qqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title - 注册', style: const TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
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
                    '注册LoCyanFrp账户',
                    style: TextStyle(fontSize: 30),
                  ),
                  Form(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: userController,
                            decoration: const InputDecoration(
                              labelText: '用户名',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              labelText: '密码',
                              prefixIcon: Icon(Icons.key),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: '重复密码',
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: '邮箱',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 285.0,
                                child: TextFormField(
                                  controller: verifyController,
                                  decoration: const InputDecoration(
                                    labelText: '邮件验证代码',
                                    prefixIcon: Icon(Icons.numbers),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100.0,
                                child: Transform.translate(
                                  offset: Offset(10.0, 0.0),
                                  child: Container(
                                    margin: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (emailController.text != '') {
                                          Get.snackbar(
                                            '正在请求',
                                            '正在请求发送验证码',
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration:
                                                Duration(milliseconds: 300),
                                          );
                                          final res = await RegisterAuth()
                                              .requestCode(
                                                  emailController.text);
                                          if (res is bool) {
                                            if (res) {
                                              Get.snackbar(
                                                '操作成功',
                                                '已发送，如未收到请检查垃圾箱',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                animationDuration:
                                                    Duration(milliseconds: 300),
                                              );
                                            } else {
                                              Get.snackbar(
                                                '操作失败',
                                                '发生失败，内部错误',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                animationDuration:
                                                    Duration(milliseconds: 300),
                                              );
                                            }
                                          } else {
                                            Get.snackbar(
                                              '操作失败',
                                              '发送失败，原因：${res.toString()}',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              animationDuration:
                                                  Duration(milliseconds: 300),
                                            );
                                          }
                                        } else {
                                          Get.snackbar(
                                            '操作失败',
                                            '请输入邮箱',
                                            snackPosition: SnackPosition.BOTTOM,
                                            animationDuration:
                                                Duration(milliseconds: 300),
                                          );
                                        }
                                      },
                                      child: Text('获取'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(6.0),
                          child: TextFormField(
                            controller: qqController,
                            decoration: const InputDecoration(
                              labelText: 'QQ',
                              prefixIcon: Icon(Icons.code),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final res = await RegisterAuth().requestRegister(
                                userController.text,
                                passwordController.text,
                                confirmPasswordController.text,
                                emailController.text,
                                verifyController.text,
                                qqController.text,
                              );
                              if (res is bool) {
                                if (res) {
                                  Get.snackbar(
                                    '注册成功',
                                    '正在自动登录',
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                  );
                                  final res_login =
                                      await LoginAuth().requestLogin(
                                    userController.text,
                                    passwordController.text,
                                  );

                                  /// 从登录页面抄过来的
                                  if (res_login is UserInfoModel) {
                                    //UserInfoCache.info = res;
                                    //print(UserInfoCache.info);
                                    await UserInfoPrefs.setInfo(res_login);
                                    UserInfoPrefs.saveToFile();
                                    Get.snackbar(
                                      '登录成功',
                                      '欢迎您，指挥官 ${res_login.user}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration:
                                          Duration(milliseconds: 300),
                                    );
                                    Get.toNamed('/panel/home');
                                  } else {
                                    Get.snackbar(
                                      '登录失败',
                                      '无法自动完成登录，请尝试手动登录，原因： ${res_login.toString()}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration:
                                          Duration(milliseconds: 300),
                                    );
                                    Get.toNamed('/login');
                                  }
                                } else {
                                  Get.snackbar(
                                    '操作失败',
                                    '注册失败，内部错误',
                                    snackPosition: SnackPosition.BOTTOM,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  '操作失败',
                                  '注册失败，原因：${res.toString()}',
                                  snackPosition: SnackPosition.BOTTOM,
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                );
                              }
                            },
                            child: Text('注册'),
                          ),
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
