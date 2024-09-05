import 'package:nyalcf_core/models/response/response.dart';

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
