// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';

/// 登录成功响应
/// [userInfo] 用户信息
class LoginSuccessResponse extends Response {
  LoginSuccessResponse({
    required this.userInfo,
    super.status = true,
    required super.message,
  });

  final UserInfoModel userInfo;
}
