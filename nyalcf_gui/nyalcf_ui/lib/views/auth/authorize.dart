// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/auth/oauth/access_token.dart';
import 'package:nyalcf_core/network/client/api/user/frp/token.dart';
import 'package:nyalcf_core/network/client/api/user/info.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/network/server/oauth.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/widgets/nya_loading_circle.dart';
import 'package:nyalcf_ui/widgets/nya_scaffold.dart';

class AuthorizeUI extends StatefulWidget {
  const AuthorizeUI({super.key});

  @override
  State<AuthorizeUI> createState() => _AuthorizeState();
}

class _AuthorizeState extends State<AuthorizeUI> {
  final _Controller ctr = Get.put(_Controller());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __) => OAuth.close,
      child: NyaScaffold(
        name: '授权',
        appbarActions: AppbarActions(),
        body: Center(
          child: Container(
            // 设置内容区域外边距
            margin: const EdgeInsets.all(40.0),
            child: ListView(
              // 设置自动缩小
              shrinkWrap: true,
              // 设置内容列表项
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '授权以继续',
                      style: TextStyle(fontSize: 30),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Obx(() => Visibility(
                                visible: ctr.authorizing.value,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('正在等待授权...'),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: NyaLoadingCircle(
                                          height: 12.0, width: 12.0),
                                    ),
                                  ],
                                ),
                              )),
                          Obx(() => Visibility(
                                visible: (!ctr.authorizing.value &&
                                    ctr.error.value != null),
                                child: Text('授权发生错误: ${ctr.error}'),
                              )),
                          Obx(() => Visibility(
                                visible: (!ctr.authorizing.value &&
                                    ctr.error.value == null),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(ctr.message.value),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: NyaLoadingCircle(
                                          height: 12.0, width: 12.0),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    const url = 'https://dashboard.locyanfrp.cn/auth/oauth/authorize'
        '?app_id=1'
        '&scopes=User,Proxy,Sign'
        '&redirect_url=http://localhost:21131/oauth/callback';
    launchUrl(Uri.parse(url));
    OAuth.initRoute(
      response: OAuthResponseBody(success: '授权成功', error: '授权失败'),
      callback: ctr.callback,
    );
    OAuth.close();
    OAuth.start();
    super.initState();
  }

  @override
  void dispose() {
    OAuth.close();
    super.dispose();
  }
}

class _Controller extends GetxController {
  var authorizing = true.obs;
  Rx<String?> error = null.obs;
  var message = ''.obs;

  void callback({
    String? refreshToken,
    String? error,
  }) async {
    if (error != null) {
      this.error.value = error;
    } else {
      ApiClient api = ApiClient();
      message.value = '已取得返回数据，正在获取访问令牌，请稍后...';
      final rs = await api
          .post(PostAccessToken(appId: 1, refreshToken: refreshToken!));
      if (rs == null) {
        _failed();
        return;
      }
      final int userId = rs.data['data']['user_id'];
      final String accessToken = rs.data['data']['access_token'];
      TokenInfoPrefs.setRefreshToken(refreshToken);
      TokenInfoPrefs.setAccessToken(accessToken);

      api = ApiClient(accessToken: accessToken);

      // Frp Token
      message.value = '正在获取 Frp Token，请稍后...';
      final rsz = await api.get(GetToken(userId: userId));
      if (rsz == null) {
        _failed();
        return;
      }
      await TokenInfoPrefs.setFrpToken(rsz.data['data']['frp_token']);

      // 用户信息
      message.value = '正在获取用户信息，请稍后...';
      final rsx = await api.get(GetInfo(userId: userId));
      if (rsx == null) {
        _failed();
        return;
      }
      // Logger.info(rsx.data);
      await UserInfoPrefs.setInfo(UserInfoModel(
        id: rsx.data['data']['id'],
        username: rsx.data['data']['username'],
        email: rsx.data['data']['email'],
        avatar: "https://cravatar.cn/avatar/"
            "${md5.convert(utf8.encode(rsx.data['data']['email']))}",
        inbound: rsx.data['data']['inbound'],
        outbound: rsx.data['data']['outbound'],
        traffic: num.parse(rsx.data['data']['traffic']),
      ));
      await UserInfoPrefs.saveToFile();

      message.value = '欢迎!';
      Get.toNamed('/panel/home');
    }
    authorizing.value = false;
  }

  _failed() {
    Get.snackbar(
      '请求数据失败',
      '请重新授权哦',
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 300),
    );
    Get.toNamed('/');
    OAuth.close();
  }
}
