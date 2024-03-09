import 'package:dio/dio.dart';
import 'package:nyalcf/models/proxy_info_model.dart';
import 'package:nyalcf/models/proxy_status_model.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class ProxiesStatusDio {
  final dio = Dio(options);

  Future<ProxyStatusModel> getProxyStatus(
      ProxyInfoModel proxy, String token) async {
    Map<String, dynamic> paramsMap = {};
    paramsMap['token'] = token;
    paramsMap['proxy_name'] = proxy.proxyName;
    paramsMap['proxy_type'] = proxy.proxyType;
    paramsMap['node_id'] = proxy.node;

    //Logger.debug(paramsMap);
    
    try {
      final res = await dio.get('$apiV2Url/proxies/getStatus',
          queryParameters: paramsMap);
      Logger.debug(res);
      final Map<String, dynamic> data = res.data['data'];
      return ProxyStatusModel(
        status: data['status'],
      );
    } catch (e) {
      Logger.debug(e);
      return ProxyStatusModel(
        status: null,
      );
    }
  }
}
