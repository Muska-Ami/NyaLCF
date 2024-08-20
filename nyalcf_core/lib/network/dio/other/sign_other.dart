import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/response_type.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';

class OtherSign {
  static final instance = dio.Dio(options);

  /// 检查签到状态
  /// [username] 用户名
  /// [token] 登录令牌
  static Future<Response> checkSign(String username, String token) async {
    // Logger.debug(token);
    try {
      // dio.FormData data = dio.FormData.fromMap({
      //   'token': token,
      // });
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      dio.Options options = dio.Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      final resData = await instance.get(
        '$apiV2Url/sign/check',
        options: options,
        queryParameters: paramsMap,
        // data: data,
      );

      Logger.debug(resData);

      Map<String, dynamic> resJson = resData.data;
      // final String msg = resJson['message'];
      if (resData.statusCode == 200 || resData.statusCode == 403) {
        if (resJson['data']['status']) {
          return Response(
            status: true,
            message: 'OK',
            data: {
              'signed': true,
              'origin_response': resData,
            },
          );
          // final postSign =
          //     await instance.post('https://api.locyanfrp.cn/User/DoSign');
          // final postSignJson = jsonDecode(postSign.data);
          //
          // if (postSignJson['message'] == "成功") {
          //   //提示签到成功
          // } else if (postSignJson['message'] == "已经签到") {
          //   //提示已经签到过了
          // } else {
          // }
        } else {
          return Response(
            status: true,
            message: 'OK',
            data: {
              'signed': false,
              'origin_response': resData,
            },
          );
        }
      } else {
        return Response(
          status: false,
          message: 'Server error',
          data: {
            'error': 'Unknown',
          },
        );
      }
    } catch (e, st) {
      Logger.error(e, t: st);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }

  /// 执行签到
  Future<Response> doSign(String username, String token) async {
    try {
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      dio.Options options = dio.Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      final resData = await instance.get(
        '$apiV2Url/sign/sign',
        options: options,
        queryParameters: paramsMap,
      );

      Map<String, dynamic> resJson = resData.data;
      // final String msg = resJson['message'];
      if (resJson['status'] == 200) {
        // int getTraffic =
        // int.parse(msg.replaceAll(RegExp(r'[^0-9]'), '')) * 1024;
        return Response(
          status: true,
          message: 'OK',
          data: {
            'get_traffic': resJson['data']['signTraffic'] * 1024,
            'first_sign': resJson['data']['firstSign'],
            'total_sign_count': resJson['data']['totalSignCount'],
            'total_get_traffic': resJson['data']['totalSignTraffic'] * 1024,
            'origin_response': resData,
          },
        );
      } else if (resJson['status'] == 403) {
        return Response(
          status: false,
          message: 'Signed',
          data: {
            'origin_response': resData,
          },
        );
      }
      return Response(
        status: false,
        message: resJson['data']['msg'],
        data: {
          'origin_response': resData,
        },
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }
}
