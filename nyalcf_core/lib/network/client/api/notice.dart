import 'package:nyalcf_core/models/api_base_model.dart';

class GetNotice extends ApiBaseModel {
  GetNotice() : super(
    endpoint: '/notice',
    params: {},
  );
}