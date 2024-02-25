import 'package:dio/dio.dart';
import 'package:nyalcf/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class UserAuth {
  final dio = Dio();

  Future<bool> checkToken(token) async {
    try {
      Logger.info('Check token if is valid');
      Map<String, dynamic> paramsMap = {};
      paramsMap['token'] = token;

      final res = await dio.get(
        '${BasicDioConfig.api_v2_url}/check/token',
        queryParameters: paramsMap,
      );
      Logger.debug(res.data);

      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }

  Future<bool> refresh(token, username) async {
    try {
      Logger.info('Refresh user info');
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      Options options = Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      final res = await dio.get(
        '${BasicDioConfig.api_v2_url}/users/info',
        queryParameters: paramsMap,
        options: options,
      );
      final resData = res.data['data'];
      Logger.debug(res.data);

      UserInfoPrefs.setTraffic(int.parse(resData['traffic']));
      UserInfoPrefs.setFrpToken(resData['frp_token']);
      //UserInfoPrefs.setInbound(resData['inbound']);
      //UserInfoPrefs.setOutbound(resData['outbound']);

      return true;
    } catch (e) {
      Logger.error(e);
      return false;
    }
  }
}
