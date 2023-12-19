import 'package:dio/dio.dart';

import '../basicConfig.dart';

class AnnouncementDio {
  final dio = Dio();

  Future<String> get() async {
    try {
      print('Get announcement');
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
}
