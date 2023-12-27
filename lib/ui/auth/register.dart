import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/dio/auth/register.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('$title - 注册', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
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
                                icon: Icon(Icons.person),
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
                                icon: Icon(Icons.key),
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
                                icon: Icon(Icons.password),
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
                                icon: Icon(Icons.email),
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
                                      icon: Icon(Icons.numbers),
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
                                            final res = await RegisterDio().requestCode(emailController.text);
                                            if (res is bool) {
                                              if (res) {
                                                Get.snackbar(
                                                  '操作成功',
                                                  '已发送，如未收到请检查垃圾箱',
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  animationDuration: Duration(milliseconds: 300),
                                                );
                                              } else {
                                                Get.snackbar(
                                                  '操作失败',
                                                  '发生失败，内部错误',
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  animationDuration: Duration(milliseconds: 300),
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                '操作失败',
                                                '发送失败，原因：${res.toString()}',
                                                snackPosition: SnackPosition.BOTTOM,
                                                animationDuration: Duration(milliseconds: 300),
                                              );
                                            }
                                          } else {
                                            Get.snackbar(
                                              '操作失败',
                                              '请输入邮箱',
                                              snackPosition: SnackPosition.BOTTOM,
                                              animationDuration: Duration(milliseconds: 300),
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
                                icon: Icon(Icons.code),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                final res = RegisterDio().requestRegister(
                                    userController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                    emailController.text,
                                    verifyController.text,
                                    qqController.text
                                );

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
        floatingActionButton: FloatingActionButtonX().button());
  }
}
