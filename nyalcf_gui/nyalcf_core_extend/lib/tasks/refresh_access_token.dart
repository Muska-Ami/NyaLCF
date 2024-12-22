// Package imports:
import 'package:nyalcf_core/network/client/api/auth/oauth/access_token.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf_core_extend/storages/prefs/instance.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/tasks/basic.dart';

class TaskRefreshAccessToken extends TaskBasic {
  @override
  startUp({Function? callback}) async {
    this.callback = callback;

    final refreshToken = await TokenInfoPrefs.getRefreshToken();
    if (refreshToken == null) {
      if (this.callback != null) this.callback!();
      return;
    }
    final ApiClient api = ApiClient();
    final rs = await api.post(PostAccessToken(
      appId: 1,
      refreshToken: refreshToken,
    ));
    if (rs == null) {
      Logger.error('Refresh access token failed, please check your connection.');
      if (this.callback != null) this.callback!();
      return;
    }
    switch (rs.statusCode) {
      case 200:
        TokenInfoPrefs.setAccessToken(rs.data['data']['access_token']);
      case 401:
        Logger.warn('Refresh token is expired or invalid.');
        UserInfoStorage.logout();
        PrefsInstance.clear();
        return;
    }
    if (this.callback != null) this.callback!();
  }
}
