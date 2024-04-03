import 'package:nyalcf/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf/storages/configurations/launcher_configuration_storage.dart';

class StoragesInjector {
  static init() async {
    final lcs = LauncherConfigurationStorage();
    final fcs = FrpcConfigurationStorage();
    final aps = AutostartProxiesStorage();

    await lcs.initCfg();
    await fcs.initCfg();
    await aps.initCfg();

    /// Deprecated config load will remove in future.
    // await loadOldCfg();
  }
}
