// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/update_info_model.dart';
import 'package:nyalcf_core/network/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

/// 获取对象
dio.Dio get _instance {
  dio.BaseOptions options = baseOptions;
  return dio.Dio(options);
}

class Launcher {
  /// 获取版本列表
  Future<UpdateInfoModel?> latestVersion() async {
    _instance.options.validateStatus = (status) => [200].contains(status);

    final dio.Response request;
    try {
      request = await _instance.get(
        '$githubApiUrl'
        '/repos/LoCyan-Team/LoCyanFrpPureApp/releases',
      );
    } catch (e, trace) {
      Logger.error(e, t: trace);
      return null;
    }
    final response = request.data;
    final version = response[0];

    final List<String> verArr = version['tag_name'].split('+');

    return UpdateInfoModel(
      version: version['name'],
      tag: version['tag_name'],
      buildNumber: verArr[1],
      downloadUrl: version['assets'],
    );
  }
}
