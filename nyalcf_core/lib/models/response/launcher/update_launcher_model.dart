import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/update_info_model.dart';

class LauncherVersionResponse extends Response {
  LauncherVersionResponse({
    required this.updateInfo,
    super.status = true,
    required super.message,
  });

  final UpdateInfoModel updateInfo;
}
