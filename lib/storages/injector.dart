import 'package:nyalcf/storages/configurations/FrpcConfigurationStorage.dart';
import 'package:nyalcf/storages/configurations/LauncherConfigurationStorage.dart';

class StoragesInjector {
  static init() async {
    final lcs = await LauncherConfigurationStorage();
    final fcs = await FrpcConfigurationStorage();

    lcs.initCfg();
    fcs.initCfg();

    /// Deprecated config load will remove in future.
    // await loadOldCfg();
  }
}