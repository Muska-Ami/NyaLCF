import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';

class ProxiesConfigurationDio {
  final dio = Dio();

  Future<dynamic> get(String frp_token, int proxy_id) async {
    try {
      Map<String, dynamic> params_map = Map();
      params_map['action'] = 'getcfg';
      params_map['token'] = frp_token;
      params_map['id'] = proxy_id;

      final res = await dio.get('${basicConfig.frpc_config_url}',
          queryParameters: params_map);
      try {
        final Map<String, dynamic> resData = jsonDecode(res.data);
        print(res);
        if (resData['success']) {
          return resData['cfg'].replaceAll('\\n', '''
''');
        } else {
          return null;
        }
      } catch (ie) {
        print(ie);
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
