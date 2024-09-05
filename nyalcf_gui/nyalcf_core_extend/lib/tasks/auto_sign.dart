import 'package:get/get.dart';

import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core_extend/tasks/basic.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/other/other.dart';

class TaskAutoSign extends TaskBasic {
  @override
  startUp({Function? callback}) async {
    if (callback != null) this.callback = callback;
    UserInfoModel? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      String user = userinfo.user;
      String token = userinfo.token;
      final checkSignRes = await OtherSign.checkSign(user, token);
      if (checkSignRes.status) {
        checkSignRes as SignResponse;
        if (!checkSignRes.signed) {
          // 执行签到
          await sign(user, token);
        } else {
          Logger.info('Already signed, skip auto sign action.');
        }
      } else {
        Logger.warn('Can not check if signed, check your Internet connection.');
      }
    }

    if (this.callback != null) this.callback!();
  }

  sign(username, token) async {
    final doSignRes = await OtherSign().doSign(username, token);
    if (doSignRes.status) {
      doSignRes as SignDataResponse;
      Get.snackbar(
        '自动签到成功',
        doSignRes.firstSign
            ? '获得 ${doSignRes.getTraffic / 1024}GiB 流量，这是您的第一次签到呐~'
            : '获得 ${doSignRes.getTraffic / 1024}GiB 流量，您已签到 ${doSignRes.totalSignCount} 次，总计获得 ${doSignRes.totalGetTraffic / 1024} GiB 流量',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      Logger.info('Auto sign successfully.');
    } else {
      if (doSignRes.message == "Signed") {
        Logger.warn('Already signed.');
      } else {
        Logger.warn(
            'Can not sign automatically, check your Internet connection.');
      }
    }
  }
}
