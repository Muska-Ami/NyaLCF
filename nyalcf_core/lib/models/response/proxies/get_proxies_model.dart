import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';

class ProxiesResponse extends Response {
  ProxiesResponse({
    required this.proxies,
    super.status = true,
    required super.message,
  });

  final List<ProxyInfoModel> proxies;
}