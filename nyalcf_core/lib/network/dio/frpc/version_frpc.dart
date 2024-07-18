import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';

class VersionFrpc {
  final instance = dio.Dio();

  Future<Response> getLatestVersion() async {
    try {
      final resData = await instance.get(
          '$githubApiUrl/repos/LoCyan-Team/LoCyanFrpPureApp/releases/latest');
      final resJson = resData.data;
      final String latestVersion = resJson['tag_name'];
      return Response(
        status: true,
        message: 'OK',
        data: {
          'latest_version': latestVersion,
          'origin_response': resData,
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
