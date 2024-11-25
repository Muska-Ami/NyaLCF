// Package imports:

// Package imports:
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf/templates/command_implement.dart';

class Logout implements CommandImplement {
  @override
  Future<void> main(List<String> args) async {
    final userInfo = await UserInfoStorage.read();
    final res = await UserInfoStorage.sigo(userInfo?.user, userInfo?.token);

    if (res) {
      Logger.info('Session data removed.');
    } else {
      Logger.error(
          'Logout failed, please check your network connection and retry.');
    }
  }
}
