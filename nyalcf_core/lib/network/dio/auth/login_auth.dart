// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class LoginAuth {
  static final instance = dio.Dio(options);

  /// 发起登录请求
  /// [user] 用户名
  /// [password] 密码
  static Future<Response> requestLogin(String user, String password) async {
    dio.FormData data =
        dio.FormData.fromMap({'username': user, 'password': password});
    try {
      Logger.debug('Post login: $user / $password');
      final response = await instance.post('$apiV2Url/users/login', data: data);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        final userInfo = UserInfoModel(
          user: resData['username'],
          email: resData['email'],
          token: resData['token'],
          avatar: resData['avatar'],
          inbound: resData['inbound'],
          outbound: resData['outbound'],
          frpToken: resData['frp_token'],
          traffic: num.parse(resData['traffic']),
        );
        return LoginSuccessResponse(
          message: 'OK',
          userInfo: userInfo,
        );
      } else {
        return ErrorResponse(
          message: resData['message'] ?? responseJson['message'],
        );
      }
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception: e,
        stackTrace: st,
        message: e.toString(),
      );
    }
  }
}
