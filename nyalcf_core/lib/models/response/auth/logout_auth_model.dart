// Project imports:
import 'package:nyalcf_core/models/response/response.dart';

/// 登出成功响应
class LogoutSuccessResponse extends Response {
  LogoutSuccessResponse({
    super.status = true,
    required super.message,
  });
}
