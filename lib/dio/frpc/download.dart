import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcDownloadDio {
  final dio = Dio();

  /// 下载Frpc
  Future<dynamic> download({
    required String arch,
    required String platform,
    required String version,
    required ProgressCallback progressCallback,
    required CancelToken cancelToken,
    String proxy = '',
  }) async {
    try {
      if (platform == 'windows') {
        return await dio.download(
            '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v${version}/frp_LoCyanFrp-${version}_${platform}_${arch}.zip',
            '${FileIO.cache_path}/frpc.zip',
            cancelToken: cancelToken,
            onReceiveProgress: progressCallback);
      } else {
        return await dio.download(
            '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v${version}/frp_LoCyanFrp-${version}_${platform}_${arch}.tar.gz',
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
