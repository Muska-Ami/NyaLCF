import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
import 'package:nyalcf/model/ProxyInfoModel.dart';
import 'package:nyalcf/util/Logger.dart';

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
      proxies.forEach((element) {
        list.add(ProxyInfoModel(
          proxy_name: element['proxy_name'],
          use_compression: bool.parse(element['use_compression']),
          local_ip: element['local_ip'],
          node: element['node'],
          local_port: element['local_port'],
          remote_port: int.parse(element['remote_port']),
          domain: element['domain'],
          icp: element['icp'],
          sk: element['sk'],
          id: element['id'],
          proxy_type: element['proxy_type'],
          use_encryption: bool.parse(element['use_encryption']),
          status: element['status'],
        ));
      });
      return list;
    } catch (e) {
      Logger.error(e);
      return e;
    }
  }
}
