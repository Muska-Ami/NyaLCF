// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class OtherAnnouncement {
  static final instance = dio.Dio(options);

  /// 获取 Notice
  static Future<Response> getNotice() async {
    try {
      Logger.info('Get notice');
      final response = await instance.get(
        '$apiV2Url/notice',
        options: dio.Options(
          validateStatus: (status) => [200].contains(status),
        ),
      );
      Logger.debug(response.data);
      return NoticeResponse(
        message: 'OK',
        broadcast: response.data['data']['broadcast'],
        announcement: response.data['data']['announcement'],
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception: e,
        message: e.toString(),
      );
    }
  }
}
