import 'package:nyalcf_core/models/frpc_version_model.dart';
import 'package:nyalcf_core/models/response/response.dart';

class FrpcSingleVersionResponse extends Response {
  FrpcSingleVersionResponse({
    required this.version,
    super.status = true,
    required super.message,
  });

  final FrpcVersionModel version;
}

class FrpcVersionsResponse extends Response {
  FrpcVersionsResponse({
    required this.versions,
    super.status = true,
    required super.message,
  });

  final List<FrpcVersionModel> versions;
}
