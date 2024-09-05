import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/models/response/response.dart';

class OtherAnnouncement {
  static final instance = dio.Dio(options);

  /// 获取网站 Broadcast
  static Future<Response> getBroadcast() async {
    try {
      Logger.info('Get broadcast announcement');
      final response = await instance.get('$apiV1Url/App/GetBroadCast');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return BroadcastResponse(
        message: 'OK',
        broadcast: resData['broadcast'],
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception: e,
        message: e.toString(),
      );
    }
  }

  /// 获取网站 Ads
  Future<Response> getAds() async {
    try {
      Logger.info('Get common announcement');
      final response = await instance.get('$apiV1Url/App');
      Logger.debug(response);
      final Map<String, dynamic> resData = response.data;
      return AdsResponse(
        status: true,
        message: 'OK',
        ads: resData['ads'],
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
