import 'package:dio/dio.dart';
import 'package:nyalcf/models/proxy_info_model.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class ProxiesGetDio {
  final dio = Dio(options);

  Future<dynamic> get(username, token) async {
    try {
      Map<String, dynamic> paramsMap = {};
      paramsMap['username'] = username;

      Options options = Options();
      Map<String, dynamic> optionsMap = {};
      optionsMap['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      optionsMap['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: optionsMap);

      //print(options.headers?.keys);

      var response = await dio.get(
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
      return list;
    } catch (e) {
      Logger.error(e);
      return e;
    }
  }
}
