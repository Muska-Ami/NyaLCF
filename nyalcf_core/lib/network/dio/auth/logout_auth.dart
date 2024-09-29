// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class LogoutAuth {
  static dio.Dio _getInstance(String token) => dio.Dio(optionsWithToken(token));

  /// 请求登出
  /// [user] 用户名
  /// [token] 登录令牌
  static Future<Response> requestLogout(String user, String token) async {
    final instance = _getInstance(token);
    try {
      Logger.debug('Logout: $user / $token');
      final response = await instance.delete(
        '$apiV2Url/user/token',
        queryParameters: {
          'username': user,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
      );
      Logger.debug(response.data);
      if (response.statusCode == 200) {
        return LogoutSuccessResponse(
          message: 'OK',
        );
      } else {
        return ErrorResponse(
          message: response.data['message'],
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
