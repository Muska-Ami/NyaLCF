// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesGet {
  static dio.Dio _getInstance(String token) => dio.Dio(optionsWithToken(token));

  /// 获取隧道列表
  /// [username] 用户名
  /// [token] 登录令牌
  static Future<Response> get(String username, String token) async {
    final instance = _getInstance(token);
    try {
      //print(options.headers?.keys);

      var response = await instance.get(
        '$apiV2Url/proxy/all',
        queryParameters: {
          'username': username,
        },
        options: dio.Options(
          validateStatus: (status) => [200, 403, 500].contains(status),
        ),
      );
      Logger.debug(response.data);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> proxies =
            List.from(response.data['data']['list']);
        List<ProxyInfoModel> list = <ProxyInfoModel>[];
        for (var proxy in proxies) {
          list.add(ProxyInfoModel(
            proxyName: proxy['proxy_name'],
            useCompression: proxy['use_compression'],
            localIP: proxy['local_ip'],
            node: proxy['node_id'],
            localPort: proxy['local_port'],
            // remote_port: int.parse(proxy['remote_port']),
            remotePort: proxy['remote_port'],
            domain: proxy['domain'],
            icp: proxy['icp'],
            sk: proxy['sk'],
            id: proxy['id'],
            proxyType: proxy['proxy_type'],
            useEncryption: proxy['use_encryption'],
            status: proxy['status'],
          ));
        }
        return ProxiesResponse(
          message: 'OK',
          proxies: list,
        );
      } else {
        return ErrorResponse(
          message: response.data['message'],
        );
      }
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception: e,
        stackTrace: st,
        message: e.toString(),
      );
    }
  }
}
