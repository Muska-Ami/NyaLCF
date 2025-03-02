// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';

// Project imports:
import 'process_manager.dart';

class FrpcStartUpLoader {
  /// 自动启动隧道
  void onProgramStartUp() async {
    final aps = AutostartProxiesStorage();
    final proxiesList = aps.getList();
    final pm = FrpcProcessManager();
    final UserController uc = Get.find();
    final execPath = await FrpcPathProvider.frpcPath();

    if (execPath != null) {
      for (var proxy in proxiesList) {
        Logger.info('Starting proxy: $proxy');
        await pm.newProcess(
          frpToken: uc.frpToken.value,
          proxyId: proxy,
          frpcPath: execPath,
        );
      }
    }
  }
}
