import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/util/FileIO.dart';

class FrpcManagerStorage {
  static final _s_path = FileIO.support_path;

  static Future<String> get _path async {
    return '${await _s_path}/frpc';
  }

  static get infoJson async {
    final infoString = File('${await _path}/info.json').readAsString();
    return jsonDecode(await infoString);
  }

  static init() {
    _path.then((path) {
      if (!Directory(path).existsSync()) Directory(path).createSync();
      final infoF = File('${path}/info.json');
      if (!infoF.existsSync()) {
        Map<String, dynamic> json = Map();
        json['settings']['using_version'] = '';
        json['settings']['using_github_proxy'] = <String>[];
        json['lists']['downloaded_versions'] = <String>[];
        json['lists']['github_proxies'] = <String>[];
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
  static get usingVersion async {
    final version = await infoJson['using_version'];
    return version;
  }

  /// 自定义GitHub代理列表
  static get proxies async {
    final url = await infoJson['github_proxies'];
    return url;
  }

  /// GitHub代理
  static get proxyUrl async {
    final url = await infoJson['using_github_proxy'];
    return url;
  }

  /// 获取已安装版本列表
  static Future<List<String>> get downloadedVersions async {
    final versions = await infoJson['downloaded_versions'];
    print(versions);
    return versions;
  }
}
