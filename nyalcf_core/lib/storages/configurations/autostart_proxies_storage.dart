// Dart imports:
import 'dart:io';

// Project imports:
import 'package:nyalcf_core/storages/json_configuration.dart';
import 'package:nyalcf_core/utils/logger.dart';

class AutostartProxiesStorage extends JsonConfiguration {
  @override
  File get file => File('$path/frpc/proxies/autostart.json');

  @override
  String get handle => 'PROXIES_AUTOSTART';

  @override
  Map<String, dynamic> get defConfig => {
        'list': [],
      };

  /// 获取自动启动隧道列表
  List getList() => cfg.getList('list', defConfig['list']);

  /// 添加自动启动隧道
  /// [proxyId] 隧道 ID
  void appendList(int proxyId) {
    List list = getList();
    Logger.debug(list);
    list.add(proxyId);
    list = list.toSet().toList();
    Logger.debug(list);
    cfg.setList('list', list);
  }

  /// 移除自动启动隧道
  /// [proxyId] 隧道 ID
  void removeFromList(int proxyId) {
    List list = getList();
    Logger.debug(list);
    list.remove(proxyId);
    list = list.toSet().toList();
    Logger.debug(list);
    cfg.setList('list', list);
  }

  /// 清除自动启动隧道列表
  void clearList() => cfg.setList('list', []);
}
