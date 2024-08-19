import 'package:nyalcf/templates/command_implement.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

class Logout implements CommandImplement {
  @override
  Future<void> main(List<String> args) async {
    final userInfo = await UserInfoStorage.read();
    await UserInfoStorage.sigo(userInfo?.user, userInfo?.token);

    Logger.info('Session data removed.');
  }

}