// Dart imports:

// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';

// Project imports:
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

class FrpcPathProvider {
  static final _fss = FrpcStorage();
  static final _fcs = FrpcConfigurationStorage();

  /// 获取 Frpc 工作目录路径
  static Future<String> get frpcWorkPath async =>
      await _fss.getRunPath(_fcs.getSettingsFrpcVersion());

  /// 获取 Frpc 可执行文件路径
  static Future<String?> frpcPath(
      {String? version, bool skipCheck = false}) async {
    final String? path;
    final String? appFrpcPath = await _fss.getFilePath(skipCheck: skipCheck);
    final String? envFrpcPath = ENV_UNIVERSAL_FRPC_PATH;
    if (envFrpcPath != null) {
      path = envFrpcPath;
    } else {
      path = appFrpcPath;
    }
    return path;
  }
}
