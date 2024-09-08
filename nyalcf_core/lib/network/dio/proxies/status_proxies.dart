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
      ProxyInfoModel proxy, String token) async {
    Map<String, dynamic> paramsMap = {};
    paramsMap['token'] = token;
    paramsMap['proxy_name'] = proxy.proxyName;
    paramsMap['proxy_type'] = proxy.proxyType;
    paramsMap['node_id'] = proxy.node;

    //Logger.debug(paramsMap);

    try {
      final res = await instance.get('$apiV2Url/proxies/status',
          queryParameters: paramsMap);
      Logger.debug(res);
      final Map<String, dynamic> data = res.data['data'];
      return ProxyStatusResponse(
        message: 'OK',
        online: data['status'],
      );
    } catch (e) {
      Logger.debug(e);
      return ErrorResponse(
        exception: e,
        message: e.toString(),
      );
    }
  }
}
