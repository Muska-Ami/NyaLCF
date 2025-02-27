// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/auth/oauth/access_token.dart';
import 'package:nyalcf_core/network/client/api/user/info.dart' as api_user;
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/instance.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_core_extend/tasks/refresh_access_token.dart';
import 'package:nyalcf_core_extend/tasks/update_proxies_list.dart';
import 'package:nyalcf_core_extend/utils/frpc/startup_loader.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/console_controller.dart';
import 'package:nyalcf_ui/controllers/frpc_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/widgets/nya_loading_circle.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class HomeUI extends StatelessWidget {
  HomeUI({super.key});

  // _HC控制器实例
  final hc = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Get.put(FrpcController());
    Get.put(ConsoleController());
    Get.put(UserController());
    // 加载hc控制器
    hc.load();

    // 构建首页Scaffold
    return NyaScaffold(
      name: '首页',
      // 设置应用栏操作按钮
      appbarActions: AppbarActions(context: context),
      appbarAutoImplyLeading: false,
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
                            child: NyaLoadingCircle(height: 22.0, width: 22.0),
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
                      const Text('にゃ~にゃ~，请授权以继续~'),
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
                                    onPressed: () =>
                                        Get.toNamed('/auth/authorize'),
                                    child: const Text('授权'),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () =>
                                    Get.toNamed('/auth/token_mode/login'),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Icon(Icons.arrow_right),
                                    Container(
                                      // 对齐，防止强迫症当场死亡
                                      margin: const EdgeInsets.only(right: 7.0),
                                      child: const Text('仅使用使用 Frp Token 继续'),
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
    );
  }
}

// _HC控制器
class HomeController extends GetxController {
  static bool loaded = false;

  // 内容列表
  var showAutoLoginWidget = false.obs;

  // 加载控制器
  load({bool force = false}) async {
    authorizeFailed() {
      UserInfoStorage.logout();
      PrefsInstance.clear();
      Get.snackbar(
        '授权失效',
        '请重新授权哦',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      showAutoLoginWidget.value = false;
    }

    if (loaded && !force) return;
    loaded = true;
    // 读取用户信息
    UserInfoModel? userInfo = await UserInfoStorage.read();
    Logger.debug(userInfo);
    if (userInfo != null) {
      UserInfoPrefs.setInfo(userInfo);

      showAutoLoginWidget.value = true;
      // 刷新用户信息
      final ApiClient api = ApiClient(
        accessToken: await TokenInfoPrefs.getAccessToken(),
      );

      final rs = await api.get(
        api_user.GetInfo(
          userId: userInfo.id,
        ),
      );
      if (rs == null) {
        Get.snackbar(
          '请求数据失败',
          '请重新授权哦',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 300),
        );
        showAutoLoginWidget.value = false;
        return;
      }
      switch (rs.statusCode) {
        case 200:
          UserInfoPrefs.setTraffic(num.parse(rs.data['data']['traffic']));
          UserInfoPrefs.setInbound(rs.data['data']['inbound']);
          UserInfoPrefs.setOutbound(rs.data['data']['outbound']);
          UserInfoPrefs.saveToFile();
          break;
        case 401:
          final apix = ApiClient();
          final refreshToken = await TokenInfoPrefs.getRefreshToken();
          if (refreshToken != null) {
            final rsAcc = await apix.post(
              PostAccessToken(
                appId: 1,
                refreshToken: refreshToken,
              ),
            );
            if (rsAcc == null) {
              authorizeFailed();
              return;
            }
            await TokenInfoPrefs.setAccessToken(
                rsAcc.data['data']['access_token']);
            // 刷新用户信息
            load(force: true);
            return;
          } else {
            authorizeFailed();
            return;
          }
        default:
          Logger.warn(
            'Check user token success but refresh user info failed.'
            ' User info may not the latest!',
          );
      }
      TaskUpdateProxiesList().startUp();
      TaskRefreshAccessToken().startUp();
      FrpcStartUpLoader().onProgramStartUp();
      // 显示自动登录的SnackBar
      Get.snackbar(
        '欢迎回来',
        '已经自动登录啦~',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      // 跳转到面板首页
      if (deeplinkStartup) {
        Logger.info('Skipped routing to panel due deeplink execution');
        return;
      }
      Get.toNamed('/panel/home');
    } else {
      // 重新初始化启动内容
      showAutoLoginWidget.value = false;
    }
  }
}
