import 'package:dio/dio.dart';
import 'package:nyalcf/models/update_info_model.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class LauncherUpdateDio {
  final dio = Dio(options);

  Future<UpdateInfoModel?> getUpdate() async {
    try {
      final res =
          await dio.get('$githubApiUrl/repos/Muska-Ami/NyaLCF/releases/latest');
      final Map<String, dynamic> resData = res.data;
      // print(resData);
      return UpdateInfoModel(
        version: resData['name'],
        tag: resData['tag_name'],
        downloadUrl: resData['assets'],
      );
    } catch (e) {
      Logger.error(e);
      return null;
    }
  }
}
