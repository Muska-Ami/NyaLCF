import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

class DownloadFrpc {
  static final dio = Dio(options);
  static final _cachePath = appCachePath;

  static late final _version;
  static late final _platform;
  static late final _architecture;
  static late final _owner;
  static late final _repo;
  static late final _releaseName;
  static late final _suffix;

  static final _fcs = FrpcConfigurationStorage();

  /// 下载Frpc
  static Future<dynamic> download({
    required String arch,
    required String platform,
    required String version,
    required String releaseName,
    required ProgressCallback progressCallback,
    required CancelToken cancelToken,
    required bool useMirror,
    String? mirrorId = null,
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
      String downloadUrl = '';
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
        if (mirrorId == null)
          throw UnimplementedError(
              'No mirrors format input! Please check your arguments.');

        final mirrorList = _fcs.getDownloadMirrors();
        for (var mirror in mirrorList) {
          if (mirror['id'] == mirrorId)
            downloadUrl = _replacePlaceholder(mirror['format']);
        }
        if (downloadUrl.isEmpty)
          throw UnimplementedError(
              'No valid mirror found. Please check your input.');
        // : '$githubMirrorsUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download' +
        //     '/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_' +
        //     '${_platform}_$_architecture.$_suffix';
      } else {
        downloadUrl =
            '$githubMainUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download' +
                '/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_' +
                '${_platform}_$_architecture.$_suffix';
      }

      Logger.debug('Downloading file: $downloadUrl');

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

  static _replacePlaceholder(String str) {
    return str
        .replaceAll('{version}', Uri.encodeComponent(_version))
        .replaceAll(
            '{version_pure}', Uri.encodeComponent(_version.split('-')[0]))
        .replaceAll('{arch}', Uri.encodeComponent(_architecture))
        .replaceAll('{owner}', Uri.encodeComponent(_owner))
        .replaceAll('{repo}', Uri.encodeComponent(_repo))
        .replaceAll('{release_name}', Uri.encodeComponent(_releaseName))
        .replaceAll('{suffix}', Uri.encodeComponent(_suffix))
        .replaceAll('{platform}', Uri.encodeComponent(_platform));
  }
}
