import 'package:dio/dio.dart';
import 'package:nyalcf/utils/network/dio/basicConfig.dart';
import 'package:nyalcf/models/UpdateInfoModel.dart';
import 'package:nyalcf/utils/Logger.dart';

class LauncherUpdateDio {
  final dio = Dio();

  Future<UpdateInfoModel?> getUpdate() async {
    try {
      final res = await dio.get(
          '${BasicDioConfig.github_api_url}/repos/Muska-Ami/NyaLCF/releases/latest');
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
