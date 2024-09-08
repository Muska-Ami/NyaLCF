// Project imports:
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesStorage {
  static final List<ProxyInfoModel> _proxies = <ProxyInfoModel>[];

  /// 添加一个隧道信息
  /// [proxy] 隧道 ID
  static void add(ProxyInfoModel proxy) {
    Logger.debug('Add proxy: $proxy');
    _proxies.add(proxy);
  }

  /// 添加多个隧道信息
  /// [proxies] 隧道列表
  static void addAll(List<ProxyInfoModel> proxies) {
    for (var element in proxies) {
      add(element);
    }
  }

  /// 获取隧道列表
  static List<ProxyInfoModel> get() => _proxies;

  /// 清除隧道列表
  static void clear() {
    Logger.debug('Clear proxies list');
    _proxies.clear();
  }
}
