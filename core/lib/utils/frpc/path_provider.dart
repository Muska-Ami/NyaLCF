// Dart imports:

// Package imports:
import 'package:core_env/env.dart';

// Project imports:
import 'package:core/storages/configurations/frpc_configuration_storage.dart';
import 'package:core/storages/stores/frp_client_storage.dart';

class FrpcPathProvider {
  static final _fs = FrpClientStorage();
  static final _fcs = FrpcConfigurationStorage();

  /// 获取 Frpc 工作目录路径
  static Future<String> getWorkPath() async =>
      await _fs.getRunPath(_fcs.getSettingsFrpcVersion());

  /// 获取 Frpc 可执行文件路径
  static Future<String?> getExecutablePath({
    String? version,
    bool skipCheck = false,
  }) async {
    return Env.universal.frpcPath ??
        await _fs.getFilePath(skipCheck: skipCheck);
  }
}
