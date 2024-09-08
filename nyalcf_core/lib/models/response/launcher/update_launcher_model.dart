import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/models/update_info_model.dart';

/// 启动器版本更新信息响应
/// [updateInfo] 新版信息
class LauncherVersionResponse extends Response {
  LauncherVersionResponse({
    required this.updateInfo,
    super.status = true,
    required super.message,
  });

  final UpdateInfoModel updateInfo;
}
