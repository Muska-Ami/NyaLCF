import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
import 'package:nyalcf/model/FrpcList.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcDownloadDio {
  final dio = Dio();

  /*
  Future<FrpcList> fetchVersion() async {
    final response =
        await dio.get('${basicConfig.github_api_url}/repos/${basicConfig.frpc_release_repo}/releases/latest');
    final Map<String, dynamic> resJson = jsonDecode(response.data);
    final Map<int, dynamic> assets = resJson['assets'];
    for (var i in assets.) {

    }
  }

   */

  Future<dynamic> download(
      {required String arch,
      required String platform,
      required ProgressCallback progressCallback,
      required CancelToken cancelToken,
      String proxy = ''}) async {
    try {
      return await dio.download(
          '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v0.51.3/frp_LoCyanFrp-0.51.3_windows_amd64.zip',
          '${FileIO.cache_path}/frpc.zip',
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback);
    } on DioException {
      if (cancelToken.isCancelled)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }
}
