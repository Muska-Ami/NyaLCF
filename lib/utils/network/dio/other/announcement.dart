import 'package:dio/dio.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class AnnouncementDio {
  final dio = Dio(options);

  Future<String?> getBroadcast() async {
    try {
      Logger.info('Get broadcast announcement');
      final response = await dio.get('$apiV1Url/App/GetBroadCast');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return resData['broadcast'];
    } catch (ex) {
      Logger.error(ex);
      return null;
    }
  }

  Future<String?> getCommon() async {
    try {
      Logger.info('Get common announcement');
      final response = await dio.get('$apiV1Url/App');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return resData['ads'];
    } catch (ex) {
      Logger.error(ex);
      return null;
    }
  }
}
