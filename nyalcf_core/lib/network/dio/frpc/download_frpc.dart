// Dart imports:

// Package imports:
import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

class DownloadFrpc {
  static final _instance = dio.Dio(options);
  static final _cachePath = appCachePath;

  static late String _version;
  static late String _platform;
  static late String _architecture;
  static late String _owner;
  static late String _repo;
  static late String _releaseName;
  static late String _suffix;

  static final _fcs = FrpcConfigurationStorage();

  /// 下载 Frpc
  /// [arch] 架构
  /// [platform] 平台
  /// [version] 版本
  /// [releaseName] 发行名称
  /// [progressCallback] 进度回调函数
  /// [cancelToken] 取消下载令牌
  /// [useMirror] 镜像源设置
  /// [mirrorId] 镜像源位于配置中的ID
  static Future<Response> download({
    required String arch,
    required String platform,
    required String version,
    required String releaseName,
    required dio.ProgressCallback progressCallback,
    required dio.CancelToken cancelToken,
    required bool useMirror,
    String? mirrorId,
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

      final envUrl = ENV_UNIVERSAL_FRPC_DOWNLOAD_MIRROR_URL;
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
        if (mirrorId == null) {
          throw UnimplementedError(
              'No mirrors format input! Please check your arguments.');
        }

        final mirrorList = _fcs.getDownloadMirrors();
        for (var mirror in mirrorList) {
          if (mirror['id'] == mirrorId) {
            downloadUrl = _replacePlaceholder(mirror['format']);
          }
        }
        if (downloadUrl.isEmpty) {
          throw UnimplementedError(
              'No valid mirror found. Please check your input.');
        }
        // : '$githubMirrorsUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download' +
        //     '/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_' +
        //     '${_platform}_$_architecture.$_suffix';
      } else {
        downloadUrl =
            '$githubMainUrl/LoCyan-Team/LoCyanFrpPureApp/releases/download/v$_version/frp_LoCyanFrp-${_version.split('-')[0]}_${_platform}_$_architecture.$_suffix';
      }

      Logger.debug('Downloading file: $downloadUrl');

      final instance = await _instance.download(
        downloadUrl,
        '$_cachePath/frpc.$_suffix',
        cancelToken: cancelToken,
        onReceiveProgress: progressCallback,
      );
      return FrpcDownloadResponse(
        cancelled: false,
        instance: instance,
        message: 'Downloaded',
      );
    } on dio.DioException catch (e, st) {
      if (cancelToken.isCancelled) {
        return FrpcDownloadResponse(
          status: false,
          cancelled: true,
          message: 'Cancelled',
        );
      } else {
        Logger.error(e, t: st);
        return ErrorResponse(
          exception: e,
          stackTrace: st,
          message: e.toString(),
        );
      }
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception: e,
        stackTrace: st,
        message: e.toString(),
      );
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
