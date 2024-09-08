// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesConfiguration {
  static final dio = Dio(options);

  /// 获取隧道启动配置
  /// [frpToken] Frp 令牌
  /// [proxyId] 隧道ID
  static Future<dynamic> get(String frpToken, int proxyId) async {
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
