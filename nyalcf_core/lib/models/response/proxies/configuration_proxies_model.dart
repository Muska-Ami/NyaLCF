// Project imports:
import 'package:nyalcf_core/models/response/response.dart';

/// 隧道列表响应
/// [proxies] 隧道列表
class ConfigurationResponse extends Response {
  ConfigurationResponse({
    required this.config,
    super.status = true,
    required super.message,
  });

  final String config;
}

