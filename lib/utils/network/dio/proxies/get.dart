import 'package:dio/dio.dart';
import 'package:nyalcf/utils/network/dio/basicConfig.dart';
import 'package:nyalcf/models/ProxyInfoModel.dart';
import 'package:nyalcf/utils/Logger.dart';

class ProxiesGetDio {
  final dio = Dio();

  Future<dynamic> get(username, token) async {
    try {
      Map<String, dynamic> params_map = Map();
      params_map['username'] = username;

      Options options = Options();
      Map<String, dynamic> options_map = Map();
      options_map['Content-Type'] =
          'application/x-www-form-urlencoded;charset=UTF-8';
      options_map['Authorization'] = 'Bearer $token';
      options = options.copyWith(headers: options_map);

      //print(options.headers?.keys);

      var response = await dio.get(
        '${basicConfig.api_v2_url}/proxies/getlist',
        queryParameters: params_map,
        options: options,
      );
      Map<String, dynamic> resJson = response.data;
      Map<String, dynamic> resData = resJson['data'];
      Logger.debug(resData['proxies']);
      List<Map<String, dynamic>> proxies = List.from(resData['proxies']);
      List<ProxyInfoModel> list = <ProxyInfoModel>[];
      proxies.forEach((proxy) {
        list.add(ProxyInfoModel(
          proxy_name: proxy['proxy_name'],
          use_compression: proxy['use_compression'],
          local_ip: proxy['local_ip'],
          node: proxy['node'],
          local_port: proxy['local_port'],
          // remote_port: int.parse(proxy['remote_port']),
          remote_port: proxy['remote_port'],
          domain: proxy['domain'],
          icp: proxy['icp'],
          sk: proxy['sk'],
          id: proxy['id'],
          proxy_type: proxy['proxy_type'],
          use_encryption: proxy['use_encryption'],
          status: proxy['status'],
        ));
      });
      return list;
    } catch (e) {
      Logger.error(e);
      return e;
    }
  }
}
