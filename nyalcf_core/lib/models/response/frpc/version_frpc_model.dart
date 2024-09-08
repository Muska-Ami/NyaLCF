import 'package:nyalcf_core/models/frpc_version_model.dart';
import 'package:nyalcf_core/models/response/response.dart';

/// 单个 Frpc 版本数据响应
/// [version] 版本
class FrpcSingleVersionResponse extends Response {
  FrpcSingleVersionResponse({
    required this.version,
    super.status = true,
    required super.message,
  });

  final FrpcVersionModel version;
}

/// Frpc 版本列表数据响应
/// [versions] 版本列表
class FrpcVersionsResponse extends Response {
  FrpcVersionsResponse({
    required this.versions,
    super.status = true,
    required super.message,
  });

  final List<FrpcVersionModel> versions;
}
