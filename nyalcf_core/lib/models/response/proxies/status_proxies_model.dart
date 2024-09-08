import 'package:nyalcf_core/models/response/response.dart';

/// 单个隧道状态响应
/// [online] 是否在线
class ProxyStatusResponse extends Response {
  ProxyStatusResponse({
    required this.online,
    super.status = true,
    required super.message,
  });

  final bool online;
}
