import 'package:nyalcf_core/models/response/response.dart';

class LogoutSuccessResponse extends Response {
  LogoutSuccessResponse({
    super.status = true,
    required super.message,
  });
}
