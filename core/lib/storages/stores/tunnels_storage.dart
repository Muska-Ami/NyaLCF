// Project imports:
import 'package:core/storages/models/tunnel.dart';
import 'package:core/utils/logger/logger.dart';

class TunnelsStorage {
  static final List<Tunnel> _tunnels = <Tunnel>[];

  /// 添加一个隧道信息
  /// [proxy] 隧道 ID
  static void add(Tunnel proxy) {
    Logger.debug('Add tunnel: $proxy');
    _tunnels.add(proxy);
  }

  /// 添加多个隧道信息
  /// [proxies] 隧道列表
  static void addAll(List<Tunnel> proxies) {
    for (var element in proxies) {
      add(element);
    }
  }

  /// 获取隧道列表
  static List<Tunnel> getAll() => _tunnels;

  /// 获取单个隧道
  static Tunnel? get(int i) {
    for (Tunnel tunnel in _tunnels) {
      if (tunnel.id == i) return tunnel;
    }
    return null;
  }

  /// 清除隧道列表
  static void clear() {
    Logger.debug('Clearing tunnels list');
    _tunnels.clear();
  }
}
