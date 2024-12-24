// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:crypto/crypto.dart';
// Project imports:
import 'package:nyalcf/templates/command.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/auth/oauth/access_token.dart';
import 'package:nyalcf_core/network/client/api/user/frp/token.dart'
    as user_frp_token;
import 'package:nyalcf_core/network/client/api/user/info.dart' as user_info;
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/network/server/oauth.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/token_storage.dart';

class Authorize implements Command {
  static final _tokenStorage = TokenStorage();

  static bool _callback = false;
  static String? _refreshToken;

  @override
  Future<void> main(List<String> args) async {
    final ApiClient api = ApiClient();

    await startHttpServer();
    Logger.info(
      'Please open this link to authorize: '
      'http://localhost:5173/auth/oauth/authorize'
      '?app_id=1'
      '&scopes=User,Proxy,Sign'
      '&redirect_url=http://localhost:21131/oauth/callback',
    );
    Logger.write('Waiting callback...');
    while (!_callback) {}
    if (_refreshToken == null) exit(1);
    final rs = await api.post(PostAccessToken(
      appId: 1,
      refreshToken: _refreshToken!,
    ));
    if (rs == null) exit(1);
    final int userId = rs.data['data']['user_id'];
    final String accessToken = rs.data['data']['access_token'];
    _tokenStorage.setRefreshToken(_refreshToken!);
    _tokenStorage.setAccessToken(accessToken);

    final apix = ApiClient(accessToken: accessToken);
    final rsInfo = await apix.get(user_info.GetInfo(
      userId: userId,
    ));
    final rsFrpToken = await apix.get(user_frp_token.GetToken(
      userId: userId,
    ));
    if (rsInfo == null || rsFrpToken == null) exit(1);
    final userInfo = UserInfoModel(
      username: rsInfo.data['data']['username'],
      id: rsInfo.data['data']['id'],
      email: rsInfo.data['data']['email'],
      avatar: "https://cravatar.cn/avatar/"
          "${md5.convert(utf8.encode(rsInfo.data['data']['email']))}",
      inbound: rsInfo.data['data']['inbound'],
      outbound: rsInfo.data['data']['outbound'],
      traffic: rsInfo.data['data']['traffic'],
    );
    UserInfoStorage.save(userInfo);
    final frpToken = rsFrpToken.data['data']['frp_token'];
    _tokenStorage.setFrpToken(frpToken);
  }

  Future<void> startHttpServer() async {
    OAuth.initRoute(
      response: OAuthResponseBody(success: '授权成功', error: '授权失败'),
      callback: callback,
    );
    await OAuth.start();
  }

  void callback({String? refreshToken, String? error}) {
    if (error != null) {
      Logger.error('Error: $error');
    } else {
      _refreshToken = refreshToken;
    }
    _callback = true;
  }
}
