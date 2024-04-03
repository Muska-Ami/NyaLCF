import 'dart:io';

import 'package:nyalcf/storages/json_configuration.dart';
import 'package:nyalcf/utils/logger.dart';

class AutostartProxiesStorage extends JsonConfiguration {
  @override
  File get file => File('$path/frpc/proxies/autostart.json');

  @override
  String get handle => 'PROXIES_AUTOSTART';

  @override
  Future<Map<String, dynamic>> get defConfig async => {
        'list': [],
      };

  List getList() => cfg.getList('list');

  void appendList(int proxyId) {
    List list = getList();
    Logger.debug(list);
    list.add(proxyId);
    list = list.toSet().toList();
    Logger.debug(list);
    cfg.setList('list', list);
  }

  void removeFromList(int proxyId) {
    List list = getList();
    Logger.debug(list);
    list.remove(proxyId);
    list = list.toSet().toList();
    Logger.debug(list);
    cfg.setList('list', list);
  }

  void clearList() => cfg.setList('list', []);
}
