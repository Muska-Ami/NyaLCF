import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_core/models/frpc_version_model.dart';

import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/models/response/response.dart';

class VersionFrpc {
  static final instance = dio.Dio();

  /// 获取最新 Frpc 版本信息
  static Future<Response> getLatestVersion() async {
    try {
      final resData = await instance.get(
          '$githubApiUrl/repos/LoCyan-Team/LoCyanFrpPureApp/releases/latest');
      final resJson = resData.data;
      final String latestVersion = resJson['tag_name'];
      final String latestName = resJson['name'];
      return FrpcSingleVersionResponse(
        message: 'OK',
        version: FrpcVersionModel(
          releaseName: latestName,
          tagName: latestVersion,
        ),
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception:
            e,
        stackTrace: st,
        message: e.toString(),
      );
    }
  }

  /// 获取最新 Frpc 版本信息
  static Future<Response> getAllVersion() async {
    try {
      final resData = await instance
          .get('$githubApiUrl/repos/LoCyan-Team/LoCyanFrpPureApp/releases');
      final resJson = resData.data;

      final versions = <FrpcVersionModel>[];

      for (var singleVersion in resJson) {
        final String version = singleVersion['tag_name'];
        final String name = singleVersion['name'];
        versions.add(
          FrpcVersionModel(
            releaseName: name,
            tagName: version,
          ),
        );
      }
      return FrpcVersionsResponse(
        message: 'OK',
        versions: versions,
      );
    } catch (e, st) {
      Logger.error(e, t: st);
      return ErrorResponse(
        exception:
            e,
        stackTrace: st,
        message: e.toString(),
      );
    }
  }
}
