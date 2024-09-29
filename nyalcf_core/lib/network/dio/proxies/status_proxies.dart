// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesStatus {
  static final instance = dio.Dio(options);

  /// 获取单个隧道状态
  /// [proxy] 隧道ID
  /// [token] 登录令牌
  static Future<Response> getProxyStatus(
    ProxyInfoModel proxy,
    String token,
  ) async {
    //Logger.debug(paramsMap);

    try {
      final response = await instance.get(
        '$apiV2Url/proxy/status',
        queryParameters: {'proxy_id': proxy.id, 'node_id': proxy.node},
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
      );
      Logger.debug(response.data);
      if (response.statusCode == 200) {
        return ProxyStatusResponse(
          message: 'OK',
          online: response.data['data']['online'],
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
