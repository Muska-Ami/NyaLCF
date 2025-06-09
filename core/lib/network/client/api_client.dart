// Package imports:
import 'package:dio/dio.dart' as dio;

// Project imports:
import 'package:core/network/client/api.dart';
import 'package:core/network/basic_config.dart';
import 'package:core/utils/logger/logger.dart';

class ApiClient {
  ApiClient({
    this.accessToken,
  });

  final String? accessToken;

  /// 获取对象
  dio.Dio get _instance {
    dio.BaseOptions options = dio.BaseOptions(
      headers: baseOptions.headers
    );
    if (accessToken != null) {
      options.headers.addAll({
        'Authorization': 'Bearer $accessToken',
      });
    }
    options.baseUrl = apiUrl;
    return dio.Dio(options);
  }

  /// GET
  Future<dio.Response?> get(Api api) async {
    try {
      return await _instance.get(
        api.endpoint,
        queryParameters: api.params,
        options: dio.Options(
          validateStatus: (status) => _isStatusValidate(
            status,
            api.validateStatus,
          ),
        ),
      );
    } catch (e, trace) {
      Logger.error(e, t: trace);
      return null;
    }
  }

  /// POST
  Future<dio.Response?> post(Api api) async {
    try {
      return await _instance.post(
        api.endpoint,
        queryParameters: api.params,
        options: dio.Options(
          validateStatus: (status) => _isStatusValidate(
            status,
            api.validateStatus,
          ),
        ),
      );
    } catch (e, trace) {
      Logger.error(e, t: trace);
      return null;
    }
  }

  /// DELETE
  Future<dio.Response?> delete(Api api) async {
    try {
      return await _instance.delete(
        api.endpoint,
        queryParameters: api.params,
        options: dio.Options(
          validateStatus: (status) => _isStatusValidate(
            status,
            api.validateStatus,
          ),
        ),
      );
    } catch (e, trace) {
      Logger.error(e, t: trace);
      return null;
    }
  }

  bool _isStatusValidate(int? status, List<int> validateStatus) =>
      validateStatus.contains(status);
}
