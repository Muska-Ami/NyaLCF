import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/frpc_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/storages/stories/user_info_storage.dart';
import 'package:nyalcf/models/user_info_model.dart';
import 'package:nyalcf/ui/models/appbar_actions.dart';
import 'package:nyalcf/ui/models/floating_action_button.dart';
import 'package:nyalcf/utils/network/dio/auth/user_auth.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.title});

  // 首页标题
  final String title;

  // FrpcController实例
  final FrpcController fctr = Get.put(FrpcController());

  // _HC控制器实例
  final hc = Get.put(_HC());

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    // 加载hc控制器
    hc.load();

    // 构建首页Scaffold
    return Scaffold(
      // 构建应用栏
      appBar: AppBar(
        // 设置应用栏标题
        title: Text('$title - 首页', style: const TextStyle(color: Colors.white)),
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
class _HC extends GetxController {
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
  load() async {
    if (loaded) return;
    // 读取用户信息
    UserInfoModel? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      // 检查用户令牌是否有效
      if (await UserAuth().checkToken(userinfo.token)) {
        // 刷新用户信息
        await UserAuth().refresh(userinfo.token, userinfo.user);
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
    loaded = true;
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
