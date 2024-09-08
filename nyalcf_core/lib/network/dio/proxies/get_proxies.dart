// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/proxy_info_model.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class ProxiesGet {
  static final instance = dio.Dio(options);

  /// 获取隧道列表
  /// [username] 用户名
  /// [token] 登录令牌
  static Future<Response> get(String username, String token) async {
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
      return ProxiesResponse(
        message: 'OK',
        proxies: list,
      );
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
