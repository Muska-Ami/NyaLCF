import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/models/update_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';

class UpdateLauncher {
  final instance = dio.Dio(options);

  Future<Response> getUpdate() async {
    try {
      final res = await instance
          .get('$githubApiUrl/repos/Muska-Ami/NyaLCF/releases/latest');
      final Map<String, dynamic> resData = res.data;
      // print(resData);
      // 解析信息
      String name = resData['name'];
      String buildNumber = '0';
      if (name.split('+').length == 2) {
        final info = name.split('+');
        name = info[0];
        buildNumber = info[1];
      }
      return Response(
        status: true,
        message: 'OK',
        data: {
          'update_info': UpdateInfoModel(
            version: name,
            tag: resData['tag_name'],
            buildNumber: buildNumber,
            downloadUrl: resData['assets'],
          ),
          'origin_response': res,
        },
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }
}
