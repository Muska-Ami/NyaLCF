// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';

// Project imports:
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

class FrpcPathProvider {
  final _fss = FrpcStorage();

  /// 获取 Frpc 工作目录路径
  Future<String> get frpcWorkPath async => await _fss.getRunPath();

  /// 获取 Frpc 可执行文件路径
  Future<String?> get frpcPath async {
    final String? path;
    final String? appFrpcPath = await _fss.getFilePath();
    final String? envFrpcPath = ENV_UNIVERSAL_FRPC_PATH;
    if (envFrpcPath != null) {
      path = envFrpcPath;
    } else {
      path = appFrpcPath;
    }
    return path;
  }
}
