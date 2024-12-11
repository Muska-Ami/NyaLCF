import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/models/api_base_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_core/network/basic_config.dart';

class ApiClient {
  ApiClient({
    this.accessToken,
  });

  final String? accessToken;

  /// 获取对象
  dio.Dio get _instance {
    dio.BaseOptions options = baseOptions;
    if (accessToken != null) {
      options.headers.addAll({
        'Authorization': 'Bearer $accessToken',
      });
    }
    options.baseUrl = apiV2Url;
    return dio.Dio(options);
  }

  /// GET
  Future<dio.Response?> get(ApiBaseModel api) async {
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
  Future<dio.Response?> post(ApiBaseModel api) async {
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
  Future<dio.Response?> delete(ApiBaseModel api) async {
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
