// Project imports:
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';

/// 隧道列表响应
/// [proxies] 隧道列表
class ProxiesResponse extends Response {
  ProxiesResponse({
    required this.proxies,
    super.status = true,
    required super.message,
  });

  final List<ProxyInfoModel> proxies;
}
