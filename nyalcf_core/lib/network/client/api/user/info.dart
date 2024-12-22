// Project imports:
import 'package:nyalcf_core/models/api_base_model.dart';

class GetInfo extends ApiBaseModel {
  GetInfo({
    required num userId,
  }) : super(
          endpoint: '/user/info',
          params: {
            'user_id': userId,
          },
        );
}
