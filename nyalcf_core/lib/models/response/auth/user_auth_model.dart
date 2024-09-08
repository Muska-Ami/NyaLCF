import 'package:nyalcf_core/models/response/response.dart';

/// 用户信息响应
/// [traffic] 剩余流量
/// [inbound] 上行带宽
/// [outbound] 下行带宽
class UserInfoResponse extends Response {
  UserInfoResponse({
    required this.traffic,
    required this.inbound,
    required this.outbound,
    super.status = true,
    required super.message,
  });

  final num traffic;
  final int inbound;
  final int outbound;
}
