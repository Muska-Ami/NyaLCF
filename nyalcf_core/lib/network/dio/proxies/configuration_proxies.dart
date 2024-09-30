// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/proxies/configuration_proxies_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesConfiguration {
  static dio.Dio _getInstance(String token) => dio.Dio(optionsWithToken(token));

  /// 获取隧道启动配置
  /// [frpToken] Frp 令牌
  /// [proxyId] 隧道ID
  static Future<Response> get(String username, String token, int proxyId) async {
    final instance = _getInstance(token);
    try {
      final response = await instance.get(
        '$apiV2Url/proxy/config',
        queryParameters: {
          'username': username,
          'proxy_id': proxyId,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 404, 500].contains(status),
        ),
      );
      if (response.statusCode == 200) {
        return ConfigurationResponse(
          config: response.data['data']['config'],
          message: 'OK',
        );
      } else {
        return ErrorResponse(
          message: response.data['message'],
        );
      }
    } catch (e) {
      Logger.debug(e);
      return ErrorResponse(
        exception: e,
        message: e.toString(),
      );
    }
  }
}
