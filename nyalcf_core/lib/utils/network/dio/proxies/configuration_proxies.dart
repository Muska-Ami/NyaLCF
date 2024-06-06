import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/basic_config.dart';

class ProxiesConfiguration {
  final dio = Dio(options);

  Future<dynamic> get(String frpToken, int proxyId) async {
    try {
      Map<String, dynamic> paramsMap = {};
      paramsMap['action'] = 'getcfg';
      paramsMap['token'] = frpToken;
      paramsMap['id'] = proxyId;

      final res = await dio.get(frpcConfigUrl, queryParameters: paramsMap);
      try {
        final Map<String, dynamic> resData = jsonDecode(res.data);
        Logger.debug(res);
        if (resData['success']) {
          return resData['cfg'].replaceAll('\\n', '''
''');
        } else {
          return null;
        }
      } catch (ie, st) {
        Logger.error(ie, t: st);
        return null;
      }
    } catch (e) {
      return e;
    }
  }
}
