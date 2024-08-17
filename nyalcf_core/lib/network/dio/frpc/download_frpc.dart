import 'dart:io';

import 'package:dio/dio.dart';

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

class DownloadFrpc {
  final dio = Dio(options);
  final _cachePath = appCachePath;

  late final _version;
  late final _platform;
  late final _architecture;
  late final _owner;
  late final _repo;
  late final _releaseName;
  late final _suffix;

  /// 下载Frpc
  Future<dynamic> download({
    required String arch,
    required String platform,
    required String version,
    required String releaseName,
    required ProgressCallback progressCallback,
    required CancelToken cancelToken,
    required bool useMirror,
    String? mirrorFormat = null,
    // version 版本 | owner 仓库所有者 | release_name 发行版本名称 | repo 仓库名 | arch 架构 | suffix 后缀名 | platform 平台
  }) async {
    Logger.info('Start download: $platform | $version | $arch');

    // 变量处理部分
    _version = version;
    _platform = platform;
    _architecture = arch;
    _owner = 'LoCyan-Team';
    _repo = 'LoCyanFrpPureApp';
    _releaseName = releaseName;
    _suffix = platform == 'windows' ? 'zip' : 'tar.gz';

    try {
      // final String downloadBasicUrl;

      final envUrl = Platform.environment['NYA_LCF_FRPC_DOWNLOAD_MIRROR_URL'];
      final downloadUrl;
      // '$downloadBasicUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download/v$version/frp_LoCyanFrp-${version.toString().split('-')[0]}_${platform}_$arch.$suffix';

      // if (useMirror) {
      //   final envUrl = Platform.environment['NYA_LCF_FRPC_DOWNLOAD_MIRROR_URL'];
      //   downloadBasicUrl =
      //       (envUrl?.substring(envUrl.length - 1, envUrl.length) == '/'
      //               ? envUrl?.substring(envUrl.length - 2, envUrl.length - 1)
      //               : envUrl) ??
      //           githubMirrorsUrl;
      // } else {
      //   downloadBasicUrl = githubMainUrl;
      // }

      // Logger.info('Download frpc using: $downloadBasicUrl');

      if (envUrl != null) {
        downloadUrl = _replacePlaceholder(envUrl);
      } else if (useMirror) {
        downloadUrl = mirrorFormat != null
            ? _replacePlaceholder(mirrorFormat)
            : '$githubMirrorsUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download' +
                '/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_' +
                '${_platform}_$_architecture.$_suffix';
      } else {
        downloadUrl =
            '$githubMainUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download' +
                '/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_' +
                '${_platform}_$_architecture.$_suffix';
      }

      return await dio.download(
        downloadUrl,
        '$_cachePath/frpc.$_suffix',
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

  _replacePlaceholder(String str) {
    return str
        .replaceAll('{version}', _version)
        .replaceAll('{version_pure}', _version.split('-')[0])
        .replaceAll('{arch}', _architecture)
        .replaceAll('{owner}', _owner)
        .replaceAll('{repo}', _repo)
        .replaceAll('{release_name}', _releaseName)
        .replaceAll('{suffix}', _suffix)
        .replaceAll('{platform}', _platform);
  }
}
