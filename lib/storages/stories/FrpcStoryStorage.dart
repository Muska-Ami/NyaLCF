import 'dart:io';

import 'package:nyalcf/storages/configurations/FrpcConfigurationStorage.dart';
import 'package:nyalcf/utils/PathProvider.dart';
import 'package:nyalcf/utils/Logger.dart';

class FrpcStoryStorage {
  static final _s_path = PathProvider.appSupportPath;
  static final fcs = FrpcConfigurationStorage();

  static Future<String> get _path async {
    return '${_s_path}/frpc';
  }

  /// 获取Frpc文件
  static Future<File> getFile() async {
    return File(await getFilePath());
  }

  /// 获取Frpc文件
  static Future<String> getFilePath() async {
    final name;
    if (Platform.isWindows)
      name = 'frpc.exe';
    else
      name = 'frpc';
    return await getRunPath() + name;
  }

  /// 获取Frpc运行路径
  static Future<String> getRunPath() async {
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

  static Future<void> setRunPermission() async {
    Logger.info('Set run permission: ${await getFilePath()}');
    final process = await Process.run(
      'chmod',
      [
        'u+x',
        await getFilePath(),
      ],
    );
    Logger.debug(process.stdout.toString());
    Logger.debug(process.stderr.toString());
  }
}
