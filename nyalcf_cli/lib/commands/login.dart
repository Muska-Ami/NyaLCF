// Package imports:
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/client/api_client.dart';
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/token_storage.dart';
import 'package:nyalcf_core_extend/utils/text_encrypt.dart';

// Project imports:
import 'package:nyalcf/templates/command.dart';

class Login implements Command {
  static final _tokenStorage = TokenStorage();

  @override
  Future<void> main(List<String> args) async {
    if (args.length == 2) {
      final ApiClient api = ApiClient();
      // TODO: OAuth2.0 Authorize
      final res = await LoginAuth.requestLogin(args[0], args[1]);
      if (res.status) {
        final UserInfoModel userInfo = res.userInfo;
        Logger.info('Login successfully.');
        Logger.info('Info:');
        Logger.info('- name: ${userInfo.username}');
        Logger.info('- email: ${userInfo.email}');
        Logger.info('- frp token: ${TextEncrypt.obscure(_tokenStorage.getFrpToken() ?? '')}');
        Logger.info(
          '- speed limit: '
          '${userInfo.inbound / 1024 * 8}Mbps'
          '/'
          '${userInfo.outbound / 1024 * 8}Mbps',
        );
        Logger.info('- traffic left: ${userInfo.traffic / 1024}GiB');
        await UserInfoStorage.save(userInfo);
        Logger.info('Session saved.');
      }
    } else {
      Logger.error('No valid arguments provided.');
    }
  }
}
