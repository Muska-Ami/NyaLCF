import 'package:get/get.dart';

import 'package:nyalcf_ui/controllers/proxies_controller.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/proxies/proxies.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

class ProxiesGetter {
  static void startUp() async {
    loading.value = true;
    Logger.info('Auto updating proxies list...');
    final UserInfoModel user = await UserInfoPrefs.getInfo();
    final result = await ProxiesGet.get(user.user, user.token);

    if (result.status) {
      ProxiesStorage.clear();
      ProxiesStorage.addAll(result.data['proxies_list']);
      try {
        final ProxiesController pctr = Get.find();
        pctr.load(user.user, user.token, request: true);
      } catch (e) {
        Logger.warn(
            'Can not update proxies list widgets, maybe it is not serialized yet.');
      }
    } else {
      Logger.warn('Can not update proxies list widgets, request failed.');
      Logger.warn(result.data['error'].toString());
    }
    loading.value = false;

    Future.delayed(const Duration(minutes: 5), () {
      startUp();
    });
  }
}
