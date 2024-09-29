// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/update_info_model.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/logger.dart';

class UpdateLauncher {
  static final instance = dio.Dio(options);

  /// 获取启动器更新信息
  static Future<Response> getUpdate() async {
    try {
      final res = await instance.get(
        '$githubApiUrl/repos/Muska-Ami/NyaLCF/releases/latest',
        options: dio.Options(
          validateStatus: (status) => [200].contains(status),
        ),
      );
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
      return LauncherVersionResponse(
        message: 'OK',
        updateInfo: UpdateInfoModel(
          version: name,
          tag: resData['tag_name'],
          buildNumber: buildNumber,
          downloadUrl: resData['assets'],
        ),
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
