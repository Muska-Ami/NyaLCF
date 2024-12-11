import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/models/frpc_version_model.dart';
import 'package:nyalcf_core/network/basic_config.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

/// 获取缓存路经
final _cachePath = appCachePath;

/// 获取 Frp Client 配置数据
final _fcs = FrpcConfigurationStorage();

/// 获取对象
dio.Dio get _instance {
  dio.BaseOptions options = baseOptions;
  return dio.Dio(options);
}

class FrpClient {
  /// 获取版本列表
  Future<List<FrpcVersionModel>> version() async {
    _instance.options.validateStatus = (status) => [200].contains(status);
    final request = await _instance
        .get('$githubApiUrl/repos/LoCyan-Team/LoCyanFrpPureApp/releases');
    final response = request.data;
    List<FrpcVersionModel> list = [];
    for (Map version in response) {
      FrpcVersionModel model = FrpcVersionModel(
        name: version['name'],
        tagName: version['tag_name'],
      );
      list.add(model);
    }
    return list;
  }

  /// 下载 Frp Client
  Future<bool> download({
    required String name,
    required String version,
    required String architecture,
    required String platform,
    required dio.CancelToken cancelToken,
    required dio.ProgressCallback onReceiveProgress,
    required Function(Object error) onFailed,
    required bool useMirror,
    String? mirrorId,
  }) async {
    String owner = 'LoCyan-Team';
    String repo = 'LoCyanFrpPureApp';
    String suffix = platform == 'windows' ? 'zip' : 'tar.gz';

    String replacePlaceholder(String str) => str
        .replaceAll('{version}', Uri.encodeComponent(version))
        .replaceAll(
            '{version_main}', Uri.encodeComponent(version.split('-')[0]))
        .replaceAll(
            '{version_build}', Uri.encodeComponent(version.split('-')[1]))
        .replaceAll('{arch}', Uri.encodeComponent(architecture))
        .replaceAll('{owner}', Uri.encodeComponent(owner))
        .replaceAll('{repo}', Uri.encodeComponent(repo))
        .replaceAll('{release_name}', Uri.encodeComponent(name))
        .replaceAll('{suffix}', Uri.encodeComponent(suffix))
        .replaceAll('{platform}', Uri.encodeComponent(platform));

    // 实际下载链接
    String? downloadUrl;

    // 环境数据
    String? envUrl = ENV_UNIVERSAL_FRPC_DOWNLOAD_MIRROR_URL;

    // 镜像下载链接
    String? mirrorDownloadUrl;
    // 默认下载链接
    String defaultDownloadUrl = '$githubMainUrl'
        '/LoCyan-Team/LoCyanFrpPureApp/releases/download/'
        'v$version'
        '/'
        'frp_LoCyanFrp-${version.split('-')[0]}'
        '_'
        '$platform'
        '_'
        '$architecture.$suffix';

    final mirrorList = _fcs.getDownloadMirrors();
    if (useMirror) {
      // 使用镜像的情况却不提供 mirrorId
      assert(
        mirrorId != null,
        "\"useMirror\" is true, but no mirror id provided!",
      );
    }
    if (mirrorId != null) {
      // 查找镜像格式
      for (var mirror in mirrorList) {
        if (mirror['id'] == mirrorId) {
          mirrorDownloadUrl = replacePlaceholder(mirror['format']);
        }
      }
    }

    // 计算下载链接
    downloadUrl = envUrl != null
        ? replacePlaceholder(envUrl)
        : useMirror
            ? mirrorDownloadUrl
            : defaultDownloadUrl;
    // 不可为空，为空则抛出错误
    assert(downloadUrl != null, "\"downloadUrl\" can't be null!");

    Logger.debug('Download url: $downloadUrl');

    try {
      await _instance.download(
        downloadUrl!,
        '$_cachePath/frpc.$suffix',
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return true;
    } catch (e, trace) {
      Logger.error(e, t: trace);
      onFailed(e);
      return false;
    }
  }
}
