import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/storages/configurations/LauncherConfigurationStorage.dart';

class StoragesInjector {
  static init() async {
    final lcs = await LauncherConfigurationStorage();

    lcs.initCfg();

    /// Deprecated config load will remove in future.
    await loadOldCfg();
  }

  @deprecated
  static Future<void> loadOldCfg() async {
    FrpcManagerStorage.init();
  }
}
