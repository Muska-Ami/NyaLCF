import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';

class LoginSuccessResponse extends Response {
  LoginSuccessResponse({
    required this.userInfo,
    super.status = true,
    required super.message,
  });

  final UserInfoModel userInfo;
}
