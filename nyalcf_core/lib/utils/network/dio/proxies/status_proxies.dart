import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/network/response_type.dart';

class ProxiesStatus {
  final instance = dio.Dio(options);

  Future<Response> getProxyStatus(ProxyInfoModel proxy, String token) async {
    Map<String, dynamic> paramsMap = {};
    paramsMap['token'] = token;
    paramsMap['proxy_name'] = proxy.proxyName;
    paramsMap['proxy_type'] = proxy.proxyType;
    paramsMap['node_id'] = proxy.node;

    //Logger.debug(paramsMap);

    try {
      final res = await instance.get('$apiV2Url/proxies/getStatus',
          queryParameters: paramsMap);
      Logger.debug(res);
      final Map<String, dynamic> data = res.data['data'];
      return Response(
        status: true,
        message: 'OK',
        data: {
          'proxy_status': data['status'],
          'origin_response': res,
        },
      );
    } catch (e) {
      Logger.debug(e);
      return Response(
        status: true,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }
}
