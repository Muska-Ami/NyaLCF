import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/models/FrpcConfigModel.dart';
import 'package:nyalcf/prefs/FrpcSettingPrefs.dart';
import 'package:nyalcf/utils/PathProvider.dart';
import 'package:nyalcf/utils/Logger.dart';

@deprecated
class FrpcManagerStorage {
  static final _s_path = PathProvider.appSupportPath;

  static Future<String> get _path async {
    return '${_s_path}/frpc';
  }

  static Future<FrpcConfigModel?> read() async {
    try {
      final String result =
          await File('${_path}/info.json').readAsString(encoding: utf8);
      return FrpcConfigModel.fromJson(jsonDecode(result));
    } catch (e) {
      return null;
    }
  }

  static Future<FrpcConfigModel> get _info async =>
      FrpcSettingPrefs.getFrpcInfo();

  static void init() {
    _path.then((path) {
      if (!Directory(path).existsSync()) Directory(path).createSync();
      final infoF = File('${path}/info.json');
      if (!infoF.existsSync()) {
        Map<String, dynamic> json = {
          'settings': {
            'frpc_version': '',
            'github_mirror': true,
          },
          'lists': {
            'frpc_downloaded_versions': <String>[],
          },
        };
        infoF.writeAsStringSync(jsonEncode(json));
      }
    });
  }

  /// 获取Frpc文件
  static Future<File> getFile(String version) async {
    return File(await getFilePath(version));
  }

  /// 获取Frpc文件
  static Future<String> getFilePath(String version) async {
    final name;
    if (Platform.isWindows)
      name = 'frpc.exe';
    else
      name = 'frpc';
    return await getRunPath(version) + name;
  }

  /// 获取Frpc运行路径
  static Future<String> getRunPath(String version) async {
    var path = '${await _path}/${version}/';
    if (Platform.isWindows) path = path.replaceAll('/', '\\');
    return path;
  }

  /// 获取正在使用的版本
  static Future<String> get usingVersion async {
    final version = (await _info).frpc_version;
    return version;
  }

  /*/// 自定义GitHub代理列表
  static Future<List<String>> get proxies async {
    final url = (await _info).github_proxies;
    return url;
  }*/

  /// GitHub代理
  static Future<bool> get useGithubMirror async {
    final mirror = (await _info).github_mirror;
    return mirror;
  }

  /// 获取已安装版本列表
  static Future<List<String>> get downloadedVersions async {
    final versions = (await _info).frpc_downloaded_versions;
    Logger.debug(versions);
    return versions;
  }

  /// 存储至磁盘
  static Future<void> save(FrpcConfigModel data) async {
    final String write_data = jsonEncode(data);
    await File('${await _path}/info.json')
        .writeAsString(write_data, encoding: utf8);
  }

  static Future<void> setRunPermission() async {
    Logger.info('Set run permission: ${await getFilePath('0.51.3')}');
    final process = await Process.run(
      'chmod',
      [
        'u+x',
        await getFilePath('0.51.3'),
      ],
    );
    Logger.debug(process.stdout.toString());
    Logger.debug(process.stderr.toString());
  }
}
