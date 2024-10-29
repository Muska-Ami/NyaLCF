// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class LoginAuth {
  static final _instance = dio.Dio(options);

  /// 发起登录请求
  /// [user] 用户名
  /// [password] 密码
  static Future<Response> requestLogin(String user, String password) async {
    try {
      Logger.debug('Post login: $user');
      final response = await _instance.post(
        '$apiV2Url/auth/login',
        data: dio.FormData.fromMap({
          'username': user,
          'password': password,
        }),
        options: dio.Options(
          validateStatus: (status) => [200, 403, 404, 500].contains(status),
        ),
      );
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (response.statusCode == 200) {
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
