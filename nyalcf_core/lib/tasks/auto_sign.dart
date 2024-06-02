import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/tasks/basic.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/other/other.dart';

class TaskAutoSign extends TaskBasic {
  @override
  startUp({Function? callback}) async {
    if (callback != null) this.callback = callback;
    UserInfoModel? userinfo = await UserInfoStorage.read();
    if (userinfo != null) {
      String token = userinfo.token;
      final checkSignRes = await OtherAutoSign().checkSign(token);
      if (checkSignRes.status) {
        if (!checkSignRes.data['signed']) {
          // 执行签到
          await sign(token);
        } else {
          Logger.info('Already signed, skip auto sign action.');
        }
      } else {
        Logger.warn('Can not check if signed, check your Internet connection.');
      }
    }

    if (this.callback != null) this.callback!();
  }

  sign(token) async {
    final doSignRes = await OtherAutoSign().doSign(token);
    if (doSignRes.status) {
      Get.snackbar(
        '自动签到成功',
        '获得 ${doSignRes.data['get_traffic'] / 1024}GiB 流量',
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
