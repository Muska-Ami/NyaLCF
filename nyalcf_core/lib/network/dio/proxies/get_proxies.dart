import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';

class ProxiesGet {
  static final instance = dio.Dio(options);

  static Future<Response> get(username, token) async {
    try {
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      dio.Options options = dio.Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      //print(options.headers?.keys);

      var response = await instance.get(
        '$apiV2Url/proxies/getlist',
        queryParameters: paramsMap,
        options: options,
      );
      Map<String, dynamic> resJson = response.data;
      Map<String, dynamic> resData = resJson['data'];
      Logger.debug(resData['proxies']);
      List<Map<String, dynamic>> proxies = List.from(resData['proxies']);
      List<ProxyInfoModel> list = <ProxyInfoModel>[];
      for (var proxy in proxies) {
        list.add(ProxyInfoModel(
          proxyName: proxy['proxy_name'],
          useCompression: proxy['use_compression'],
          localIP: proxy['local_ip'],
          node: proxy['node'],
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
      return Response(
        status: true,
        message: 'OK',
        data: {
          'proxies_list': list,
          'origin_response': resData,
        },
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }
}
