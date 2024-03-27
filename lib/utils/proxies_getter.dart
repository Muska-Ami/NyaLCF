import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/proxies_controller.dart';
import 'package:nyalcf/models/proxy_info_model.dart';
import 'package:nyalcf/models/user_info_model.dart';
import 'package:nyalcf/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf/storages/stores/proxies_storage.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/proxies/get.dart';

class ProxiesGetter {
  static void startUp() async {
    Logger.info('Auto updating proxies list...');
    final UserInfoModel user = await UserInfoPrefs.getInfo();
    final dynamic result = await ProxiesGetDio().get(user.user, user.token);

    if (result is DioException) {
      Logger.warn('Can not update proxies list widgets, request failed.');
      Logger.warn(result.toString());
    } else if (result is List<ProxyInfoModel>) {
      ProxiesStorage.clear();
      ProxiesStorage.addAll(result);
      try {
        final ProxiesController pctr = Get.find();
        pctr.load(user.user, user.token);
      } catch (e) {
        Logger.warn(
            'Can not update proxies list widgets, maybe it is not serialized yet.');
      }
    } else {
      Logger.error('Unknown type of proxies list request callback.');
    }

    Future.delayed(const Duration(minutes: 5), () {
      startUp();
    });
  }
}
