import 'dart:io';

import 'package:nyalcf/utils/PathProvider.dart';

@deprecated
class FrpcConfigurationStorage {
  static var _path = PathProvider.support_path;

  /// 配置文件目录路径
  static get _configDir async {
    final dir = Directory('${await _path}/frpc/proxies');
    if (!await dir.exists()) await dir.create();
    return '${await _path}/frpc/proxies';
  }

  /// 配置文件路径
  static _startConfigPath(int proxy_id) async =>
      '${await _configDir}/${proxy_id}.nya';

  /// 设置配置文件
  static setConfig(int proxy_id, String ini) async {
    final String cp = await _startConfigPath(proxy_id);
    final f = File(cp);
    if (!(await f.exists())) f.create();
    f.writeAsString(ini);
  }

  /// 获取配置文件路径
  static Future<String?> getConfigPath(int proxy_id) async {
    final String cp = await _startConfigPath(proxy_id);
    if (await File(cp).exists())
      return cp;
    else
      return null;
  }
}
