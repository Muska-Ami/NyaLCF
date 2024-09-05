import 'package:nyalcf_core/models/response/response.dart';

class FrpcDownloadResponse extends Response {
  FrpcDownloadResponse({
    required this.cancelled,
    this.instance,
    super.status = true,
    required super.message,
  });

  final dynamic instance;
  final bool cancelled;
}
