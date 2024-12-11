import 'package:nyalcf_core/models/api_base_model.dart';

class GetAll extends ApiBaseModel {
  GetAll({
    required num userId,
  }) : super(
          endpoint: '/proxy/all',
          params: {
            'user_id': userId,
          },
        );
}
