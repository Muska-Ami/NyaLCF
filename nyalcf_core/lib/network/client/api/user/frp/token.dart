// Project imports:
import 'package:nyalcf_core/models/api_base_model.dart';

class GetToken extends ApiBaseModel {
  GetToken({
    required userId,
  }) : super(
    endpoint: '/user/frp/token',
    params: {
      'user_id': userId,
    },
  );
}
