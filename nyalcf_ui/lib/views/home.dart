import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/controllers/console_controller.dart';
import 'package:nyalcf_core/controllers/frpc_controller.dart';
import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';
import 'package:nyalcf_core/utils/frpc/startup_loader.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/auth/auth.dart';
import 'package:nyalcf_core/utils/proxies_getter.dart';

class Home extends StatelessWidget {
  Home({super.key});

  // _HC控制器实例
  final hc = Get.put(HC());

  @override
  Widget build(BuildContext context) {
    Get.put(FrpcController());
    Get.put(ConsoleController());
    Get.put(UserController());
    // 加载hc控制器
    hc.load();

    // 构建首页Scaffold
    return Scaffold(
      // 构建应用栏
      appBar: AppBar(
        // 设置应用栏标题
        title: const Text('$title - 首页', style: TextStyle(color: Colors.white)),
        // 设置应用栏操作按钮
        actions: AppbarActionsX(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
      ),
      // 构建首页内容区域
      body: Center(
        child: Container(
          // 设置内容区域外边距
          margin: const EdgeInsets.all(40.0),
          // 使用Obx包裹ListView
          child: Obx(
            () => ListView(
              // 设置自动缩小
              shrinkWrap: true,
              // 设置内容列表项
              children: hc.w,
            ),
          ),
        ),
      ),
      // 构建底部浮动生成按钮
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}

// _HC控制器
class HC extends GetxController {
  static bool loaded = false;

  // 内容列表
  var w = <Widget>[
    const Text(
      '欢迎使用Nya LoCyanFrp! Launcher',
      style: TextStyle(fontSize: 30),
    ),
    const Text('にゃ~にゃ~，检测到保存数据，正在校验以自动登录'),
    const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 22.0,
          width: 22.0,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ],
    ),
  ].obs;

  // 加载控制器
  load({bool force = false}) async {
    if (loaded && !force) return;
    loaded = true;
    // 读取用户信息
    UserInfoModel? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      // 检查用户令牌是否有效
      final checkTokenRes = await UserAuth().checkToken(userinfo.token);
      if (checkTokenRes.status) {
        // 刷新用户信息
        await UserAuth().refresh(userinfo.token, userinfo.user).then((value) {
          if (!value.status) {
            Logger.warn(
                'Check user token success but refresh user info failed. User info may not the latest!');
          }
          ProxiesGetter.startUp();
          FrpcStartUpLoader().onProgramStartUp();
        });
        // 清空内容列表
        w.value = <Widget>[];
        // 显示自动登录的SnackBar
        Get.snackbar(
          '欢迎回来',
          '已经自动登录啦~',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
        // 跳转到面板首页
        Get.toNamed('/panel/home');
      } else {
        // 显示令牌校验失败的SnackBar
        Get.snackbar(
          '令牌校验失败',
          '可能登录已过期或网络不畅，请重新登录喵呜...',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
        // 重新初始化启动内容
        _initStartup();
      }
    } else {
      // 重新初始化启动内容
      _initStartup();
    }
  }

  // 重新初始化启动内容
  _initStartup() {
    w.value = <Widget>[
      const Text(
        '欢迎使用Nya LoCyanFrp! Launcher',
        style: TextStyle(fontSize: 30),
      ),
      const Text('にゃ~にゃ~，请选择一项操作'),
      Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed('/auth/login'),
                    child: const Text('登录'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed('/auth/register'),
                    child: const Text('注册'),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Get.toNamed('/token_mode/login'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.arrow_right),
                    Container(
                      /// 对齐，防止强迫症当场死亡
                      margin: const EdgeInsets.only(right: 7.0),
                      child: const Text('仅使用使用Frp Token登录'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
