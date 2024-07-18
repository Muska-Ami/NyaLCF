import 'package:get/get.dart';

import 'package:nyalcf_core/controllers/user_controller.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/frpc/process_manager.dart';
import 'package:nyalcf_core/utils/logger.dart';

class FrpcStartUpLoader {
  /// 自动启动隧道
  void onProgramStartUp() async {
    final aps = AutostartProxiesStorage();
    final proxiesList = aps.getList();
    final pm = FrpcProcessManager();
    final UserController uc = Get.find();
    final execPath = await FrpcPathProvider().frpcPath;

    if (execPath != null) {
      for (var proxy in proxiesList) {
        Logger.info('Starting proxy: $proxy');
        pm.nwprcs(
          frpToken: uc.frpToken.value,
          proxyId: proxy,
          frpcPath: execPath,
        );
      }
    }
  }
}
