import 'package:nyalcf/templates/command_implement.dart';
import 'package:nyalcf/utils/text_encrypt.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/auth/auth.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

class Login implements CommandImplement {
  @override
  Future<void> main(List<String> args) async {
    if (args.length == 2) {
      final res = await LoginAuth.requestLogin(args[0], args[1]);
      if (res.status) {
        final UserInfoModel userInfo = res.data['user_info'];
        Logger.info('Login successfully.');
        Logger.info('Info:');
        Logger.info('- name: ${userInfo.user}');
        Logger.info('- email: ${userInfo.email}');
        Logger.info('- login token: ${TextEncrypt.obscure(userInfo.token)}');
        Logger.info('- frp token: ${TextEncrypt.obscure(userInfo.frpToken)}');
        Logger.info(
            '- speed limit: ${userInfo.inbound / 1024 * 8}Mbps/${userInfo.outbound / 1024 * 8}Mbps');
        Logger.info('- traffic left: ${userInfo.traffic / 1024}GiB');
        await UserInfoStorage.save(userInfo);
        Logger.info('Session saved.');
      }
    } else {
      Logger.error('No valid arguments provided.');
    }
  }
}
