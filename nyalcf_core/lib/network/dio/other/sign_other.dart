// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class OtherSign {
  static dio.Dio getInstance(String token) => dio.Dio(optionsWithToken(token));

  /// 检查签到状态
  /// [username] 用户名
  /// [token] 登录令牌
  static Future<Response> checkSign(String username, String token) async {
    final instance = getInstance(token);
    // Logger.debug(token);
    try {
      // dio.FormData data = dio.FormData.fromMap({
      //   'token': token,
      // });

      final response = await instance.get(
        '$apiV2Url/sign',
        queryParameters: {
          'username': username,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
        // data: data,
      );

      Logger.debug(response.data);

      if (response.statusCode == 200) {
        if (response.data['data']['status']) {
          return SignResponse(
            message: 'OK',
            signed: true,
          );
        } else {
          return SignResponse(
            message: 'OK',
            signed: false,
          );
        }
      } else {
        return ErrorResponse(
          message: response.data['message'],
        );
      }
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        message: e.toString(),
        exception: e,
        stackTrace: st,
      );
    }
  }

  /// 执行签到
  Future<Response> doSign(String username, String token) async {
    final instance = getInstance(token);
    try {
      final response = await instance.post(
        '$apiV2Url/sign',
        queryParameters: {
          'username': username,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
      );

      Logger.debug(response.data);
      // final String msg = resJson['message'];
      if (response.statusCode == 200) {
        // int getTraffic =
        // int.parse(msg.replaceAll(RegExp(r'[^0-9]'), '')) * 1024;
        return SignDataResponse(
          status: true,
          message: 'OK',
          getTraffic: response.data['data']['get_traffic'] * 1024,
          firstSign: response.data['data']['first_sign'],
          totalSignCount: response.data['data']['sign_count'],
          totalGetTraffic: response.data['data']['total_get_traffic'] * 1024,
        );
      } else if (response.statusCode == 403) {
        return ErrorResponse(
          message: 'Signed',
        );
      }
      return ErrorResponse(
        message: response.data['message'],
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
