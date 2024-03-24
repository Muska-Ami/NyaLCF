import 'package:get/get.dart';
import 'package:nyalcf/controllers/proxies_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/models/proxy_info_model.dart';
import 'package:nyalcf/storages/stores/proxies_storage.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/proxies/get.dart';

class ProxiesGetter {
  static void startUp() async {
    Logger.info('Auto updating proxies list...');
    final UserController uctr = Get.find();

    final List<ProxyInfoModel> result =
        await ProxiesGetDio().get(uctr.user, uctr.token);
    ProxiesStorage.clear();
    ProxiesStorage.addAll(result);
    try {
      final ProxiesController pctr = Get.find();
      pctr.load(uctr.user, uctr.token);
    } catch (e) {
      Logger.info(
          'Can not update proxies list widgets, maybe it is not serialized yet.');
    }
    Future.delayed(const Duration(minutes: 5), () {
      startUp();
    });
  }
}
