// Project imports:
import 'package:nyalcf_core/models/response/response.dart';

/// Frpc 下载响应
/// [instance] Dio 对象
/// [cancelled] 是否取消
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
