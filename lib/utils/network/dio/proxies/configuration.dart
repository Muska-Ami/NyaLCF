import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nyalcf/utils/network/dio/basicConfig.dart';
import 'package:nyalcf/utils/Logger.dart';

class ProxiesConfigurationDio {
  final dio = Dio();

  Future<dynamic> get(String frpToken, int proxyId) async {
    try {
      Map<String, dynamic> paramsMap = {};
      paramsMap['action'] = 'getcfg';
      paramsMap['token'] = frpToken;
      paramsMap['id'] = proxyId;

      final res = await dio.get(BasicDioConfig.frpc_config_url,
          queryParameters: paramsMap);
      try {
        final Map<String, dynamic> resData = jsonDecode(res.data);
        Logger.debug(res);
        if (resData['success']) {
          return resData['cfg'].replaceAll('\\n', '''
''');
        } else {
          return null;
        }
      } catch (ie) {
        Logger.error(ie);
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
