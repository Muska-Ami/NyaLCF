import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/frpc.dart';
import 'package:nyalcf/dio/auth/check.dart';
import 'package:nyalcf/io/userInfoStorage.dart';
import 'package:nyalcf/model/User.dart';
import 'package:nyalcf/ui/model/FloatingActionButton.dart';

import 'model/AppbarActions.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.title});

  final String title;
  final FrpcController f_c = Get.put(FrpcController());

  final hc = Get.put(_HC());

  @override
  Widget build(BuildContext context) {
    hc.load();

    return Scaffold(
        appBar: AppBar(
          title:
              Text('$title - 首页', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.pink[100],
          actions: AppbarActionsX(context: context).actions(),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40.0),
            child: Column(children: hc.w),
          ),
        ),
        floatingActionButton: FloatingActionButtonX().button());
  }
}

class _HC extends GetxController {
  var w = <Widget>[
    const Text(
      '欢迎使用Nya LoCyanFrp! Launcher',
      style: TextStyle(fontSize: 30),
    ),
    const Text('にゃ~にゃ~，请选择一项操作'),
    SizedBox(
      height: 22.0,
      width: 22.0,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    )
  ].obs;

  load() async {
    User? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      if (await CheckDio().checkToken(userinfo.token)) {
        w.value = <Widget>[];
        Get.toNamed('/panel/home');
      } else {
        Get.snackbar(
          '令牌校验失败',
          '可能登录已过期或网络不畅，请重新登录喵呜...',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: Duration(milliseconds: 300),
        );
        _initStartup();
      }
    } else {
      _initStartup();
    }
  }

  _initStartup() {
    w.value = <Widget>[
      const Text(
        '欢迎使用Nya LoCyanFrp! Launcher',
        style: TextStyle(fontSize: 30),
      ),
      const Text('にゃ~にゃ~，请选择一项操作'),
      Container(
        margin: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: const Text('登录')),
            ),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () => Get.toNamed('/register'),
                    child: const Text('注册'))),
          ],
        ),
      )
    ];
  }
}
