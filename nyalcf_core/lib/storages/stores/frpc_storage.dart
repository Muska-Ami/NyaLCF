// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/frpc/path_provider.dart';
import 'package:nyalcf_core/utils/logger.dart';

class FrpcStorage {
  static final _supportPath = appSupportPath;
  static final _fcs = FrpcConfigurationStorage();

  static Future<String> get _path async {
    return '$_supportPath/frpc';
  }

  /// 获取 Frpc 文件
  Future<File?> getFile() async {
    final String? path = await getFilePath();
    if (path != null) return File(path);
    return null;
  }

  /// 获取 Frpc 文件路径
  Future<String?> getFilePath() async {
    final String name;
    if (Platform.isWindows) {
      name = 'frpc.exe';
    } else {
      name = 'frpc';
    }
    final String path = await getRunPath() + name;
    Logger.debug('Unchecked frpc file path: $path');
    if (await File(path).exists()) {
      Logger.debug('Path check passed.');
      return path;
    } else {
      return null;
    }
  }

  /// 获取 Frpc 运行路径
  Future<String> getRunPath() async {
    var path = '${await _path}/${_fcs.getSettingsFrpcVersion()}/';
    if (Platform.isWindows) path = path.replaceAll('/', '\\');
    return path;
  }

  /// 设置 Frpc 可执行权限
  Future<void> setRunPermission() async {
    Logger.info('Set run permission: ${await getFilePath()}');
    final execPath = await FrpcPathProvider().frpcPath;
    if (execPath != null) {
      final process = await Process.run(
        'chmod',
        [
          'u+x',
          execPath,
        ],
      );
      Logger.debug(process.stdout.toString());
      Logger.debug(process.stderr.toString());
    } else {
      throw UnimplementedError('No file provided.');
    }
  }
}
