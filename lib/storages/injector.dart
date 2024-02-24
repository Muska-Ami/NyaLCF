import 'package:nyalcf/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf/storages/configurations/launcher_configuration_storage.dart';

class StoragesInjector {
  static init() async {
    final lcs = LauncherConfigurationStorage();
    final fcs = FrpcConfigurationStorage();

    await lcs.initCfg();
    await fcs.initCfg();

    /// Deprecated config load will remove in future.
    // await loadOldCfg();
  }
}
