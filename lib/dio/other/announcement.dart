import 'package:dio/dio.dart';

import '../basicConfig.dart';

class AnnouncementDio {
  final dio = Dio();

  Future<String> getBroadcast() async {
    try {
      print('Get broadcast announcement');
      final response =
          await dio.get('${basicConfig.api_v1_url}/App/GetBroadCast');
      print(response);
      final Map<String, dynamic> resData = response.data;
      return resData['broadcast'];
    } catch (ex) {
      print(ex);
      return '获取失败了啊呜，可能是猫猫把网线偷走了~';
    }
  }

  Future<String> getCommon() async {
    try {
      print('Get common announcement');
      final response =
      await dio.get('${basicConfig.api_v1_url}/App');
      print(response);
      final Map<String, dynamic> resData = response.data;
      return resData['ads'];
    } catch (ex) {
      print(ex);
      return '获取失败了啊呜，可能是猫猫把网线偷走了~';
    }
  }
}
