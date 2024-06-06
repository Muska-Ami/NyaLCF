import 'package:dio/dio.dart';

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/basic_config.dart';
import 'package:nyalcf_core/utils/path_provider.dart';

class DownloadFrpc {
  final dio = Dio(options);
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
        downloadBasicUrl = githubMirrorsUrl;
      } else {
        downloadBasicUrl = githubMainUrl;
      }

      final String suffix;
      if (platform == 'windows') {
        suffix = 'zip';
      } else {
        suffix = 'tar.gz';
      }
      return await dio.download(
        '$downloadBasicUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download/v$version/frp_LoCyanFrp-${version.toString().split('-')[0]}_${platform}_$arch.$suffix',
        '$_cachePath/frpc.$suffix',
        cancelToken: cancelToken,
        onReceiveProgress: progressCallback,
      );
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
