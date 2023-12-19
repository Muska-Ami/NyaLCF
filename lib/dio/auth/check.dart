import 'package:dio/dio.dart';

import '../basicConfig.dart';

class CheckDio {
  final dio = Dio();

  Future<bool> checkToken(token) async {
    try {
      print('Check token if is valid');
      Map<String, dynamic> params_map = Map();
      params_map['token'] = token;

      final res = await dio.get('${basicConfig.api_v2_url}/check/token',
          queryParameters: params_map);
      print(res.data);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
