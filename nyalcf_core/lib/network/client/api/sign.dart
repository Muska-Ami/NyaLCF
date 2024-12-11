import 'package:nyalcf_core/models/api_base_model.dart';

class GetSign extends ApiBaseModel {
  GetSign({
    required num userId,
  }) : super(
          endpoint: '/sign',
          params: {
            'user_id': userId,
          },
        );
}

class PostSign extends ApiBaseModel {
  PostSign({
    required num userId,
  }) : super(
          endpoint: '/sign',
          params: {
            'user_id': userId,
          },
        );
}
