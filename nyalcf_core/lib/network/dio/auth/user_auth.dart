// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class UserAuth {
  static final instance = dio.Dio(options);

  /// 检查 Token 有效性
  /// [token] 登录令牌
  static Future<Response> checkToken(String token) async {
    try {
      Logger.info('Check token if is valid');
      Map<String, dynamic> paramsMap = {};
      paramsMap['token'] = token;

      final res = await instance.get(
        '$apiV2Url/check/token',
        queryParameters: paramsMap,
      );
      Logger.debug(res.data);

      return Response(
        status: true,
        message: 'OK',
      );
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
    try {
      Logger.info('Refresh user info');
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      dio.Options options = dio.Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      final res = await instance.get(
        '$apiV2Url/users/info',
        queryParameters: paramsMap,
        options: options,
      );
      final resData = res.data['data'];
      Logger.debug(res.data);

      // Logger.debug(resData['traffic']);
      // Logger.debug(int.parse(resData['traffic']));

      return UserInfoResponse(
        message: 'OK',
        traffic: num.parse(resData['traffic']),
        inbound: resData['inbound'],
        outbound: resData['outbound'],
      );
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
