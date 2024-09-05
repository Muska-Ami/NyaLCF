import 'package:nyalcf_core/models/response/response.dart';

class SignResponse extends Response {
  SignResponse({
    required this.signed,
    super.status = true,
    required super.message,
  });

  final bool signed;
}

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
  final int totalSignCount;
  final int totalGetTraffic;
}
