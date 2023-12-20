import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/util/FileIO.dart';

class FrpcManagerStorage {
  static final _s_path = FileIO.support_path;
  static Future<String> get _path async {
    return '${await _s_path}/frpc';
  }

  static init() {
    Map<String, dynamic> json = Map();
    json['versions'] = <String>[];
  }

  /// 获取Frpc文件
  static Future<File> getFile(String version) async {
    final name;
    if (Platform.isWindows) name = 'frpc.exe'; else name = 'frpc';
    return File('${_path}/${version}/${name}');
  }

  /// 获取已安装版本列表
  static Future<List<String>> get versionList async {
    final infoString = File('${await _path}/info.json').readAsString();
    final infoJson = jsonDecode(await infoString);
    final versions = infoJson['versions'];
    print(versions);
    return versions;
  }

}
