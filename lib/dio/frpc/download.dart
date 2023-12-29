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
    print('Start download: ${platform} | ${version} | ${arch}');
    try {
      if (platform == 'windows') {
        print('Windows, download zip');
        return await dio.download(
          '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v${version}/frp_LoCyanFrp-${version}_${platform}_${arch}.zip',
          '${await FileIO.cache_path}/frpc.zip',
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback,
        );
      } else {
        print('Download tar.gz');
        return await dio.download(
          '${proxy + basicConfig.github_main_url}/LoCyan-Team/LoCyanFrpPureApp/releases/download/v${version}/frp_LoCyanFrp-${version}_${platform}_${arch}.tar.gz',
          '${await FileIO.cache_path}/frpc.tar.gz',
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback,
        );
      }
    } on DioException catch (e) {
      if (cancelToken.isCancelled)
        return true;
      else
        return e;
    } catch (e) {
      return e;
    }
  }
}
