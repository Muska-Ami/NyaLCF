import 'package:dio/dio.dart';
import 'package:nyalcf/prefs/UserInfoPrefs.dart';

import '../basicConfig.dart';

class UserUtilDio {
  final dio = Dio();

  Future<bool> checkToken(token) async {
    try {
      print('Check token if is valid');
      Map<String, dynamic> params_map = Map();
      params_map['token'] = token;

      final res = await dio.get(
        '${basicConfig.api_v2_url}/check/token',
        queryParameters: params_map,
      );
      print(res.data);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refresh(token, username) async {
    try {
      print('Refresh user info');
      Map<String, dynamic> params_map = Map();
      params_map['username'] = username;

      Options options = Options();
      Map<String, dynamic> options_map = Map();
      options_map['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      options_map['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: options_map);

      final res = await dio.get(
        '${basicConfig.api_v2_url}/users/info',
        queryParameters: params_map,
        options: options,
      );
      final resData = res.data['data'];
      print(res.data);

      UserInfoPrefs.setTraffic(resData['traffic']);
      //UserInfoPrefs.setInbound(resData['inbound']);
      //UserInfoPrefs.setOutbound(resData['outbound']);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
