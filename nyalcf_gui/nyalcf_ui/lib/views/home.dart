// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/auth/auth.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_core_extend/tasks/update_proxies_list.dart';
import 'package:nyalcf_core_extend/utils/frpc/startup_loader.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/frpc_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

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
        title: const Text('$title - 首页'),
        // 设置应用栏操作按钮
        actions: AppbarActions(context: context).actions(),
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
              children: [
                Visibility(
                  visible: hc.showAutoLoginWidget.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '欢迎使用 Nya LoCyanFrp! Launcher',
                        style: TextStyle(fontSize: 30),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Text('にゃ~にゃ~，检测到保存数据，正在校验以自动登录'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 22.0,
                              width: 22.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !hc.showAutoLoginWidget.value,
                  child: Column(
                    children: [
                      const Text(
                        '欢迎使用 Nya LoCyanFrp! Launcher',
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
                                    onPressed: () =>
                                        Get.toNamed('/auth/register'),
                                    child: const Text('注册'),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () =>
                                    Get.toNamed('/token_mode/login'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(Icons.arrow_right),
                                    Container(
                                      // 对齐，防止强迫症当场死亡
                                      margin: const EdgeInsets.only(right: 7.0),
                                      child: const Text('仅使用使用 Frp Token 登录'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // 构建底部浮动生成按钮
      floatingActionButton: floatingActionButton(),
    );
  }
}

// _HC控制器
class HC extends GetxController {
  static bool loaded = false;

  // 内容列表
  var showAutoLoginWidget = false.obs;

  // 加载控制器
  load({bool force = false}) async {
    if (loaded && !force) return;
    loaded = true;
    // 读取用户信息
    UserInfoModel? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      showAutoLoginWidget.value = true;
      // 检查用户令牌是否有效
      final checkTokenRes = await UserAuth.checkToken(userinfo.token);
      if (checkTokenRes.status) {
        // 刷新用户信息
        await UserAuth().getInfo(userinfo.token, userinfo.user).then((value) {
          if (value.status) {
            value as UserInfoResponse;
            UserInfoPrefs.setTraffic(value.traffic);
            UserInfoPrefs.setInbound(value.inbound);
            UserInfoPrefs.setOutbound(value.outbound);
          } else {
            Logger.warn(
                'Check user token success but refresh user info failed. User info may not the latest!');
          }
          TaskUpdateProxiesList().startUp();
          FrpcStartUpLoader().onProgramStartUp();
        });
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
        UserInfoStorage.sigo(
          userinfo.user,
          userinfo.token,
          deleteSessionFileOnly: true,
        );
        // 显示令牌校验失败的SnackBar
        Get.snackbar(
          '令牌校验失败',
          '可能登录已过期或网络不畅，请重新登录喵呜...',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
        // 重新初始化启动内容
        showAutoLoginWidget.value = false;
      }
    } else {
      // 重新初始化启动内容
      showAutoLoginWidget.value = false;
    }
  }
}
