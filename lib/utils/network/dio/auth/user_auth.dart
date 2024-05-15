import 'package:dio/dio.dart' as dio;
import 'package:nyalcf/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';
import 'package:nyalcf/utils/network/response_type.dart';

class UserAuth {
  final instance = dio.Dio(options);

  Future<Response> checkToken(token) async {
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
        data: {
          'origin_response': res,
        },
      );
    } catch (e) {
      Logger.error(e);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }

  Future<Response> refresh(token, username) async {
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

      UserInfoPrefs.setTraffic(int.parse(resData['traffic']));
      UserInfoPrefs.setFrpToken(resData['frp_token']);
      //UserInfoPrefs.setInbound(resData['inbound']);
      //UserInfoPrefs.setOutbound(resData['outbound']);

      return Response(
        status: true,
        message: 'OK',
        data: {
          'origin_response': res,
        },
      );
    } catch (e) {
      Logger.error(e);
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
