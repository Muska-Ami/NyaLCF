import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
import 'package:nyalcf/model/UpdateInfo.dart';

class LauncherUpdateDio {
  final dio = Dio();

  Future<UpdateInfo?> getUpdate() async {
    try {
      final res = await dio.get('${basicConfig
          .github_api_url}/repos/Muska-Ami/NyaLCF/releases/latest');
      final Map<String, dynamic> resData = res.data;
      // print(resData);
      return UpdateInfo(
          version: resData['name'],
          tag: resData['tag_name'],
          download_url: resData['assets'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}