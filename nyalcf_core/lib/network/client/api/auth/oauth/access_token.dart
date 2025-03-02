// Project imports:
import 'package:nyalcf_core/models/api_base_model.dart';

class PostAccessToken extends ApiBaseModel {
  PostAccessToken({
    required num appId,
    required String refreshToken,
  }) : super(
          endpoint: '/auth/oauth/access-token',
          params: {
            'app_id': appId,
            'refresh_token': refreshToken,
          },
          validateStatus: [200, 401],
        );
}
