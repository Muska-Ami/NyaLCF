// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/auth/oauth/access_token.dart';
import 'package:nyalcf_core/network/client/api/user/info.dart' as user_info;
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/network/server/oauth.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/token_storage.dart';

// Project imports:
import 'package:nyalcf/templates/command.dart';

import 'package:nyalcf_core/network/client/api/user/frp/token.dart'
    as user_frp_token;

class Authorize implements Command {
  static final _tokenStorage = TokenStorage();

  static bool _callback = false;
  static String? _refreshToken;

  @override
  Future<void> main(List<String> args) async {
    final ApiClient api = ApiClient();

    final port = await startHttpServer();
    await Logger.info('Please open this link to authorize:');
    await Logger.info(
      'https://dashboard.locyanfrp.cn/auth/oauth/authorize'
      '?app_id=1'
      '&scopes=User,Proxy,Sign'
      '&redirect_url='
      'https%3A%2F%2Fdashboard.locyanfrp.cn%2Fcallback%2Fauth%2Foauth%2Flocalhost%3Fport%3D$port%26ssl%3Dfalse%26path%3D%2Foauth%2Fcallback',
    );
    Logger.write('Waiting callback...');
    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 1000)); // 延迟检查
      return !_callback;
    });
    Logger.write('Continuing authorizing...\n');
    if (_refreshToken == null) {
      Logger.error('No refresh token callback, quit.');
      exit(1);
    }
    final rs = await api.post(PostAccessToken(
      appId: 1,
      refreshToken: _refreshToken!,
    ));
    if (rs == null) {
      Logger.error('Request access token failed.');
      exit(1);
    }
    final int userId = rs.data['data']['user_id'];
    final String accessToken = rs.data['data']['access_token'];
    _tokenStorage.setRefreshToken(_refreshToken!);
    _tokenStorage.setAccessToken(accessToken);

    Logger.info('Getting user info...');

    final apix = ApiClient(accessToken: accessToken);
    final rsInfo = await apix.get(user_info.GetInfo(
      userId: userId,
    ));
    final rsFrpToken = await apix.get(user_frp_token.GetToken(
      userId: userId,
    ));
    Logger.debug(rsInfo);
    Logger.debug(rsFrpToken);
    if (rsInfo == null || rsFrpToken == null) exit(1);
    final userInfo = UserInfoModel(
      username: rsInfo.data['data']['username'],
      id: rsInfo.data['data']['id'],
      email: rsInfo.data['data']['email'],
      avatar: "https://cravatar.cn/avatar/"
          "${md5.convert(utf8.encode(rsInfo.data['data']['email']))}",
      inbound: rsInfo.data['data']['inbound'],
      outbound: rsInfo.data['data']['outbound'],
      traffic: num.parse(rsInfo.data['data']['traffic']),
    );
    UserInfoStorage.save(userInfo);
    final frpToken = rsFrpToken.data['data']['frp_token'];
    _tokenStorage.setFrpToken(frpToken);
    _tokenStorage.save();
    Logger.info('Authorized success.');
    await OAuth.close();
    exit(0);
  }

  Future<int> startHttpServer() async {
    OAuth.initRoute(
      response: OAuthResponseBody(success: '授权成功', error: '授权失败'),
      callback: callback,
    );
    return await OAuth.start();
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
