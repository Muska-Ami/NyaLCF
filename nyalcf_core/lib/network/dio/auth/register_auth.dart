// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class RegisterAuth {
  static final _instance = dio.Dio(options);

  /// 请求注册
  /// [user] 用户名
  /// [password] 密码
  /// [email] 邮箱
  /// [verifyCode] 邮件验证代码
  /// [qqCode] QQ号
  static Future<Response> requestRegister(
    String user,
    String password,
    String email,
    verifyCode,
    qqCode,
  ) async {
    try {
      Logger.debug('Post register: $user - $email / $verifyCode');
      final response = await _instance.post(
        '$apiV2Url/auth/register',
        queryParameters: {
          'username': user,
          'password': password,
          'email': email,
          'verify_code': verifyCode,
          'qq_code': qqCode,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
      );
      Logger.debug(response.data);
      if (response.statusCode == 200) {
        return Response(
          status: true,
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

  Future<Response> requestCode(email) async {
    try {
      Logger.debug('Requesting email code, email: $email');
      final response = await _instance.get(
        '$apiV2Url/email/register',
        queryParameters: {
          'email': email,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 500].contains(status),
        ),
      );
      if (response.statusCode == 200) {
        return Response(
          status: true,
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
