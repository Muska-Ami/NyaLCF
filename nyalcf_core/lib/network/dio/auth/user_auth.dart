// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class UserAuth {
  static dio.Dio _getInstance(String token) => dio.Dio(optionsWithToken(token));

  /// 检查 Token 有效性
  /// [token] 登录令牌
  static Future<Response> checkToken(String token) async {
    final instance = _getInstance(token);
    try {
      Logger.info('Check token if is valid');

      final response = await instance.get(
        '$apiV2Url/user/token',
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

  /// 获取用户信息
  /// [token] 登录令牌
  /// [username] 用户名
  Future<Response> getInfo(String token, String username) async {
    final instance = _getInstance(token);
    try {
      Logger.info('Refresh user info');

      final response = await instance.get(
        '$apiV2Url/user/info',
        queryParameters: {
          'username': username,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 404, 500].contains(status),
        ),
      );
      Logger.debug(response.data);

      // Logger.debug(resData['traffic']);
      // Logger.debug(int.parse(resData['traffic']));

      if (response.statusCode == 200) {
        return UserInfoResponse(
          message: 'OK',
          traffic: num.parse(response.data['data']['traffic']),
          inbound: response.data['data']['inbound'],
          outbound: response.data['data']['outbound'],
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
