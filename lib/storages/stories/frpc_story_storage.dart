import 'dart:io';

import 'package:nyalcf/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf/utils/frpc/path_provider.dart';
import 'package:nyalcf/utils/path_provider.dart';
import 'package:nyalcf/utils/logger.dart';

class FrpcStoryStorage {
  static final _supportPath = PathProvider.appSupportPath;
  static final fcs = FrpcConfigurationStorage();

  static Future<String> get _path async {
    return '$_supportPath/frpc';
  }

  /// 获取Frpc文件
  Future<File?> getFile() async {
    final String? path = await getFilePath();
    if (path != null) return File(path);
    return null;
  }

  /// 获取Frpc文件
  Future<String?> getFilePath() async {
    final String name;
    if (Platform.isWindows) {
      name = 'frpc.exe';
    } else {
      name = 'frpc';
    }
    final String path = await getRunPath() + name;
    Logger.debug('Unchecked frpc file path: $path');
    // TODO: 修复配置文件String和StringList动态读取
    if (await File(path).exists() || await File('$_supportPath/frpc/0.51.3-2/$name').exists()) {
      Logger.debug('Path check passed.');
      return path;
    } else {
        return null;
    }
  }

  /// 获取Frpc运行路径
  Future<String> getRunPath() async {
    var path = '${await _path}/${fcs.getSettingsFrpcVersion()}/';
    if (Platform.isWindows) path = path.replaceAll('/', '\\');
    return path;
  }

  // /// 获取正在使用的版本
  // static Future<String> get usingVersion async {
  //   final version = (await _info).frpc_version;
  //   return version;
  // }
  //
  // /*/// 自定义GitHub代理列表
  // static Future<List<String>> get proxies async {
  //   final url = (await _info).github_proxies;
  //   return url;
  // }*/
  //
  // /// GitHub代理
  // static Future<bool> get useGithubMirror async {
  //   final mirror = (await _info).github_mirror;
  //   return mirror;
  // }
  //
  // /// 获取已安装版本列表
  // static Future<List<String>> get downloadedVersions async {
  //   final versions = (await _info).frpc_downloaded_versions;
  //   Logger.debug(versions);
  //   return versions;
  // }
  //
  // /// 存储至磁盘
  // static Future<void> save(FrpcConfigModel data) async {
  //   final String write_data = jsonEncode(data);
  //   await File('${await _path}/info.json')
  //       .writeAsString(write_data, encoding: utf8);
  // }

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
