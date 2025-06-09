import 'package:core/network/client/api.dart';

class GetAccessToken extends Api {
  GetAccessToken({
    required num appId,
    required String refreshToken,
  }) : super(
    endpoint: '/auth/oauth/access-token',
    method: ApiRequestMethod.post,
    params: {
      "app_id": appId,
      "refresh_token": refreshToken,
    }
  );
}