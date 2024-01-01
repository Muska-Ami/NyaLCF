import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/model/FrpcConfig.dart';
import 'package:nyalcf/prefs/SettingPrefs.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcManagerStorage {
  static final _s_path = FileIO.support_path;

  static Future<String> get _path async {
    return '${await _s_path}/frpc';
  }

  static Future<FrpcConfig?> read() async {
    try {
      final String result =
          await File('${await _path}/info.json').readAsString(encoding: utf8);
      return FrpcConfig.fromJson(jsonDecode(result));
    } catch (e) {
      return null;
    }
  }

  static Future<FrpcConfig> get _info async => SettingPrefs.getFrpcInfo();

  static void init() {
    _path.then((path) {
      if (!Directory(path).existsSync()) Directory(path).createSync();
      final infoF = File('${path}/info.json');
      if (!infoF.existsSync()) {
        Map<String, dynamic> json = {
          'settings': {
            'frpc_version': '',
            'github_proxy': <String>[],
          },
          'lists': {
            'frpc_downloaded_versions': <String>[],
            'github_proxies': <String>[
              'https://mirror.ghproxy.com/',
              'https://ghproxy.com/',
            ],
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

  /// 自定义GitHub代理列表
  static Future<List<String>> get proxies async {
    final url = (await _info).github_proxies;
    return url;
  }

  /// GitHub代理
  static Future<String> get proxyUrl async {
    final url = (await _info).github_proxy;
    return url;
  }

  /// 获取已安装版本列表
  static Future<List<String>> get downloadedVersions async {
    final versions = (await _info).frpc_downloaded_versions;
    print(versions);
    return versions;
  }

  /// 存储至磁盘
  static Future<void> save(FrpcConfig data) async {
    final String write_data = jsonEncode(data);
    await File('${await _path}/info.json')
        .writeAsString(write_data, encoding: utf8);
  }

  static Future<void> setRunPermission() async {
    final process = await Process.run(
      'chmod',
      [
        'u+x',
        await getFilePath('0.51.3'),
      ],
    );
    print(process.stdout.toString());
    print(process.stderr.toString());
  }
}
