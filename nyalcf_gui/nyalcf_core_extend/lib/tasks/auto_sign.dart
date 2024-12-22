// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/sign.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/tasks/basic.dart';

class TaskAutoSign extends TaskBasic {
  @override
  startUp({Function? callback}) async {
    if (callback != null) this.callback = callback;
    final accessToken = await TokenInfoPrefs.getAccessToken();
    UserInfoModel? userInfo = await UserInfoStorage.read();
    if (accessToken == null || userInfo == null) return;
    // 用户信息存在才操作
    final ApiClient api = ApiClient(accessToken: accessToken);

    final rs = await api.get(GetSign(userId: userInfo.id));
    if (rs == null) return;
    if (rs.statusCode == 200) {
      if (!rs.data['data']['status']) {
        // 执行签到
        await sign(userInfo.id, accessToken);
      } else {
        Logger.info('Already signed, skip auto sign action.');
      }
    } else {
      Logger.error(
        'Response error: '
        '${rs.data['message']}',
      );
    }

    if (this.callback != null) this.callback!();
  }

  sign(num userId, String token) async {
    final ApiClient api = ApiClient(accessToken: token);

    final rs = await api.post(PostSign(userId: userId));
    if (rs == null) return;
    if (rs.statusCode == 200) {
      Get.snackbar(
        '自动签到成功',
        rs.data['data']['first_sign']
            ? '获得 ${rs.data['data']['get_traffic'] / 1024}GiB 流量，这是您的第一次签到呐~'
            : '获得 ${rs.data['data']['get_traffic'] / 1024}GiB 流量，您已签到 ${rs.data['data']['sign_count']} 次，总计获得 ${rs.data['data']['total_get_traffic'] / 1024} GiB 流量',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      Logger.info('Auto sign successfully.');
    } else {
      if (rs.data['message'] == "Signed") {
        Logger.warn('Already signed.');
      } else {
        Logger.error(
          'Response error: '
          '${rs.data['message']}',
        );
      }
    }
  }
}
