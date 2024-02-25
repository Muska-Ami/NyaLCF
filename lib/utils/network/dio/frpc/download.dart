import 'package:dio/dio.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';
import 'package:nyalcf/utils/path_provider.dart';
import 'package:nyalcf/utils/logger.dart';

class FrpcDownloadDio {
  final dio = Dio();
  final _cachePath = PathProvider.appCachePath;

  /// 下载Frpc
  Future<dynamic> download({
    required String arch,
    required String platform,
    required String version,
    required ProgressCallback progressCallback,
    required CancelToken cancelToken,
    required bool useMirror,
  }) async {
    Logger.info('Start download: $platform | $version | $arch');
    try {
      final String downloadBasicUrl;
      if (useMirror) {
        downloadBasicUrl = BasicDioConfig.github_mirrors_url;
      } else {
        downloadBasicUrl = BasicDioConfig.github_main_url;
      }

      if (platform == 'windows') {
        Logger.debug('Windows, download zip');
        return await dio.download(
          '$downloadBasicUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download/v$version/frp_LoCyanFrp-${version}_${platform}_$arch.zip',
          '$_cachePath/frpc.zip',
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback,
        );
      } else {
        Logger.debug('Download tar.gz');
        return await dio.download(
          '$downloadBasicUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download/v$version/frp_LoCyanFrp-${version}_${platform}_$arch.tar.gz',
          '$_cachePath/frpc.tar.gz',
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback,
        );
      }
    } on DioException catch (e) {
      if (cancelToken.isCancelled) {
        return true;
      } else {
        return e;
      }
    } catch (e) {
      return e;
    }
  }
}
