import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/models/response/response.dart';

class RegisterAuth {
  static final instance = dio.Dio(options);

  /// 请求注册
  /// [user] 用户名
  /// [password] 密码
  /// [confirmPassword] 确认密码
  /// [email] 邮箱
  /// [verify] 邮件验证代码
  /// [qq] QQ号
  static Future<Response> requestRegister(
      user, password, confirmPassword, email, verify, qq) async {
    dio.FormData data = dio.FormData.fromMap({
      'username': user,
      'password': password,
      'confirm_password': confirmPassword,
      'email': email,
      'verify': verify,
      'qq': qq,
    });
    try {
      Logger.debug(
          'Post register: $user - $email / $password - $confirmPassword / $verify');
      final response =
          await instance.post('$apiV2Url/users/register', data: data);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        return Response(
          status: true,
          message: 'OK',
        );
      } else {
        return ErrorResponse(
          message: resData['msg'] ?? responseJson['status'],
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
      Map<String, dynamic> paramsMap = {};
      paramsMap['email'] = email;
      final response = await instance.get(
        '$apiV2Url/users/send',
        queryParameters: paramsMap,
      );
      final resData = response.data;
      if (resData['msg'] == 'success') {
        return Response(
          status: true,
          message: 'OK',
        );
      } else {
        return ErrorResponse(
          message: resData['msg'],
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
