import 'dart:io';

import 'package:nyalcf_inject/nyalcf_inject.dart';

class ProxiesConfigurationStorage {
  static final _path = appSupportPath;

  /// 配置文件目录路径
  static get _configDir async {
    final dir = Directory('$_path/frpc/proxies');
    if (!await dir.exists()) await dir.create();
    return '$_path/frpc/proxies';
  }

  /// 配置文件路径
  /// [proxyId] 隧道 ID
  static _startConfigPath(int proxyId) async =>
      '${await _configDir}/$proxyId.nya';

  /// 设置配置文件内容
  /// [proxyId] 隧道 ID
  /// [ini] 配置文件内容
  static setConfig(int proxyId, String ini) async {
    final String cp = await _startConfigPath(proxyId);
    final f = File(cp);
    if (!(await f.exists())) f.create();
    f.writeAsString(ini);
  }

  /// 获取配置文件路径
  /// [proxyId] 隧道 ID
  static Future<String?> getConfigPath(int proxyId) async {
    final String cp = await _startConfigPath(proxyId);
    if (await File(cp).exists()) {
      return cp;
    } else {
      return null;
    }
  }
}
