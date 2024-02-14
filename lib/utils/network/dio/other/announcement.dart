import 'package:dio/dio.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class AnnouncementDio {
  final dio = Dio();

  Future<String> getBroadcast() async {
    try {
      Logger.info('Get broadcast announcement');
      final response =
          await dio.get('${BasicDioConfig.api_v1_url}/App/GetBroadCast');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return resData['broadcast'];
    } catch (ex) {
      Logger.error(ex);
      return '获取失败了啊呜，可能是猫猫把网线偷走了~';
    }
  }

  Future<String> getCommon() async {
    try {
      Logger.info('Get common announcement');
      final response = await dio.get('${BasicDioConfig.api_v1_url}/App');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return resData['ads'];
    } catch (ex) {
      Logger.error(ex);
      return '获取失败了啊呜，可能是猫猫把网线偷走了~';
    }
  }
}
