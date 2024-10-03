// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/proxies/proxies.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';
import 'package:nyalcf_ui/controllers/proxies_controller.dart';

// Project imports:
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_core_extend/tasks/basic.dart';

class TaskUpdateProxiesList extends TaskBasic {
  @override
  void startUp({Function? callback}) async {
    if (callback != null) this.callback = callback;
    loading.value = true;
    Logger.info('Auto updating proxies list...');
    final UserInfoModel user = await UserInfoPrefs.getInfo();
    final result = await ProxiesGet.get(user.user, user.token);

    if (result.status) {
      result as ProxiesResponse;
      ProxiesStorage.clear();
      ProxiesStorage.addAll(result.proxies);
      _removeNonExistsAutostart(result.proxies);
      try {
        final ProxiesController pctr = Get.find();
        pctr.load(user.user, user.token, request: true);
      } catch (e) {
        Logger.warn(
            'Can not update proxies list widgets, maybe it is not serialized yet.');
      }
    } else {
      result as ErrorResponse;
      Logger.warn('Can not update proxies list widgets, request failed.');
      Logger.warn(result.exception);
    }
    loading.value = false;

    if (this.callback != null) this.callback!();
  }

  _removeNonExistsAutostart(List<ProxyInfoModel> proxies) async {
    final aps = AutostartProxiesStorage();
    final nowList = aps.getList();
    for (ProxyInfoModel item in nowList) {
      Logger.debug("${item.proxyName} not exists again, removing it from autostart.json");
      if (!proxies.contains(item)) aps.removeFromList(item.id);
    }
    aps.save();
  }
}
