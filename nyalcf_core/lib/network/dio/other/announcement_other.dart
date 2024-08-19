import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';

class OtherAnnouncement {
  static final instance = dio.Dio(options);

  static Future<Response> getBroadcast() async {
    try {
      Logger.info('Get broadcast announcement');
      final response = await instance.get('$apiV1Url/App/GetBroadCast');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return Response(
        status: true,
        message: 'OK',
        data: {
          'broadcast': resData['broadcast'],
          'origin_response': resData,
        },
      );
    } catch (ex, st) {
      Logger.error(ex, t: st);
      return Response(
        status: false,
        message: ex.toString(),
        data: {
          'error': ex,
        },
      );
    }
  }

  Future<Response> getAds() async {
    try {
      Logger.info('Get common announcement');
      final response = await instance.get('$apiV1Url/App');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return Response(
        status: true,
        message: 'OK',
        data: {
          'ads': resData['ads'],
          'origin_response': resData,
        },
      );
    } catch (ex, st) {
      Logger.error(ex, t: st);
      return Response(
        status: false,
        message: ex.toString(),
        data: {
          'error': ex,
        },
      );
    }
  }
}
