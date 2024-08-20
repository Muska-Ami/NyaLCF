import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';
import 'package:nyalcf_core/utils/logger.dart';

class LogoutAuth {
  static final instance = dio.Dio(options);

  /// 请求登出
  /// [user] 用户名
  /// [token] 登录令牌
  static Future<Response> requestLogout(user, token) async {
    Map<String, dynamic> paramsMap = {};
    paramsMap['username'] = user;

    Map<String, dynamic> optionsMap = {};
    optionsMap['Content-Type'] =
    'application/x-www-form-urlencoded;charset=UTF-8';
    optionsMap['Authorization'] = 'Bearer $token';
    options = options.copyWith(headers: optionsMap);

    try {
      Logger.debug('Logout: $user / $token');
      final response = await instance.delete('$apiV2Url/users/reset/token/single', queryParameters: paramsMap);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        return Response(
          status: true,
          message: 'OK',
          data: {
            'origin_response': resData,
          },
        );
      } else {
        return Response(
          status: false,
          message: resData['msg'] ?? responseJson['status'],
          data: {
            'origin_response': resData,
          },
        );
      }
    } catch (ex, st) {
      Logger.error(ex, t: st);
      return Response(
        status: false,
        message: ex.toString(),
        data: {
          'error': ex,
        },
      );
    }
  }
}