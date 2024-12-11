// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api/proxy/all.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/stores/proxies_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
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
    final accessToken = await TokenInfoPrefs.getAccessToken();
    final UserInfoModel user = await UserInfoPrefs.getInfo();

    final api = ApiClient(accessToken: accessToken);

    final rs = await api.get(GetAll(userId: user.id));
    if (rs == null) {
      if (this.callback != null) this.callback!();
      return;
    }
    if (rs.statusCode == 200) {
      final List<Map<String, dynamic>> list = rs.data['data']['list'];

      final List<ProxyInfoModel> proxies = [];
      for (Map<String, dynamic> proxy in list) {
        final model = ProxyInfoModel(
          id: proxy['id'],
          name: proxy['proxy_name'],
          node: proxy['node_id'],
          localIP: proxy['local_ip'],
          localPort: proxy['local_port'],
          remotePort: proxy['remote_port'],
          proxyType: proxy['proxy_type'],
          useEncryption: proxy['use_encryption'],
          useCompression: proxy['use_compression'],
          domain: proxy['domain'],
          secretKey: proxy['secret_key'],
          status: proxy['status'],
        );
        proxies.add(model);
      }

      ProxiesStorage.clear();
      ProxiesStorage.addAll(proxies);
      _removeNonExistsAutostart(proxies);
      try {
        final ProxiesController pCtr = Get.find();
        pCtr.load(request: true);
      } catch (e) {
        Logger.warn(
          'Can not update proxies list widgets,'
          ' maybe it is not serialized yet.',
        );
      }
    } else {
      Logger.error(
        'Response error: '
        '${rs.data['message']}',
      );
    }
    loading.value = false;

    if (this.callback != null) this.callback!();
  }

  _removeNonExistsAutostart(List<ProxyInfoModel> proxies) async {
    final aps = AutostartProxiesStorage();
    final nowList = aps.getList();
    for (ProxyInfoModel item in nowList) {
      Logger.debug(
        "${item.name} not exists again,"
        " removing it from autostart.json",
      );
      if (!proxies.contains(item)) aps.removeFromList(item.id);
    }
    aps.save();
  }
}
