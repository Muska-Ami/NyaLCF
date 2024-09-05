import 'package:nyalcf_core/models/response/response.dart';

class ProxyStatusResponse extends Response {
  ProxyStatusResponse({
    required this.online,
    super.status = true,
    required super.message,
  });

  final bool online;
}