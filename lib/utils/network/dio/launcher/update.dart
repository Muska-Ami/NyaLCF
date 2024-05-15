import 'package:dio/dio.dart' as dio;
import 'package:nyalcf/models/update_info_model.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';
import 'package:nyalcf/utils/network/response_type.dart';

class LauncherUpdateDio {
  final instance = dio.Dio(options);

  Future<Response> getUpdate() async {
    try {
      final res = await instance
          .get('$githubApiUrl/repos/Muska-Ami/NyaLCF/releases/latest');
      final Map<String, dynamic> resData = res.data;
      // print(resData);
      return Response(
        status: true,
        message: 'OK',
        data: {
          'update_info': UpdateInfoModel(
            version: resData['name'],
            tag: resData['tag_name'],
            downloadUrl: resData['assets'],
          ),
          'origin_response': res,
        },
      );
    } catch (e) {
      Logger.error(e);
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
