import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesStorage {
  static final List<ProxyInfoModel> _proxies = <ProxyInfoModel>[];

  /// 添加一个隧道信息
  static void add(ProxyInfoModel proxy) {
    Logger.debug('Add proxy: $proxy');
    _proxies.add(proxy);
  }

  static void addAll(List<ProxyInfoModel> proxies) {
    for (var element in proxies) {
      add(element);
    }
  }

  static List<ProxyInfoModel> get() => _proxies;

  /// 清除列表
  static void clear() {
    Logger.debug('Clear proxies list');
    _proxies.clear();
  }
}
