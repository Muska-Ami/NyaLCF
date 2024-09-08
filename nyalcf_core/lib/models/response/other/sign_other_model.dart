import 'package:nyalcf_core/models/response/response.dart';

/// 签到状态响应
/// [signed] 是否已签到
class SignResponse extends Response {
  SignResponse({
    required this.signed,
    super.status = true,
    required super.message,
  });

  final bool signed;
}

/// 签到数据响应
/// [getTraffic] 签到获得的流量
/// [firstSign] 是否为第一次签到
/// [totalGetTraffic] 通过签到总共获得的流量
/// [totalSignCount] 总签到次数
class SignDataResponse extends Response {
  SignDataResponse({
    required this.getTraffic,
    required this.firstSign,
    required this.totalSignCount,
    required this.totalGetTraffic,
    super.status = true,
    required super.message,
  });

  final num getTraffic;
  final bool firstSign;
  final num totalSignCount;
  final int totalGetTraffic;
}
