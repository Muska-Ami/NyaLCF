import 'package:nyalcf_core/storages/configurations/autostart_proxies_storage.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';

class StoragesInjector {
  static init() async {
    final _lcs = LauncherConfigurationStorage();
    final _fcs = FrpcConfigurationStorage();
    final aps = AutostartProxiesStorage();

    await _lcs.initCfg();
    await _fcs.initCfg();
    await aps.initCfg();

    /// Deprecated config load will remove in future.
    // await loadOldCfg();
  }
}
