import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
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

  /// 下载Frpc
  Future<dynamic> download({
    required String arch,
    required String platform,
    required ProgressCallback progressCallback,
    required CancelToken cancelToken,
    String proxy = '',
  }) async {
    try {
      if (platform == 'windows') {
        return await dio.download(
            '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v0.51.3/frp_LoCyanFrp-0.51.3_${platform}_${arch}.zip',
            '${FileIO.cache_path}/frpc.zip',
            cancelToken: cancelToken,
            onReceiveProgress: progressCallback);
      } else {
        return await dio.download(
            '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v0.51.3/frp_LoCyanFrp-0.51.3_${platform}_${arch}.tar.gz',
            '${FileIO.cache_path}/frpc.tar.gz',
            cancelToken: cancelToken,
            onReceiveProgress: progressCallback);
      }
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
