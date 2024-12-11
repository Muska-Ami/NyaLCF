import 'package:nyalcf_core/models/api_base_model.dart';

class GetConfig extends ApiBaseModel {
  GetConfig({
    required num userId,
    num? proxyId,
    num? nodeId,
  }) : super(endpoint: '/proxy/config', params: {
          'user_id': userId,
          'proxy_id': proxyId,
          'node_id': nodeId,
        });
}
