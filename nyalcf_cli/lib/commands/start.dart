import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/utils/state.dart';
import 'package:nyalcf/utils/templates/command_implement.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

class Start implements CommandImplement {
  @override
  Future<void> main(List<String> args) async {
    if (args.isNotEmpty) {
      final user = await userInfo;
      if (user != null) {
        for (var proxyId in args) {
          final frpcPath = await FrpcStorage().getFilePath();
          final runPath = await FrpcStorage().getRunPath();

          if (frpcPath != null) {
            final process = await Process.start(
              frpcPath,
              [
                '-u',
                user.frpToken,
                '-p',
                proxyId,
              ],
              workingDirectory: runPath,
            );
            process.stdout.forEach((List<int> element) {
              final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
              final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
              Logger.frpcInfo(proxyId, fmtStr);
            });
            process.stderr.forEach((List<int> element) {
              final RegExp regex = RegExp(r'\x1B\[[0-9;]*[mK]');
              final String fmtStr = utf8.decode(element).trim().replaceAll(regex, '');
              Logger.frpcError(proxyId, fmtStr);
            });
            Logger.info('Started proxy: $proxyId');
          } else {
            Logger.error('You have no frpc installed yet!');
          }
        }
      } else {
        Logger.error('You have no login session yet!');
      }
    } else {
      Logger.error('No valid arguments provided.');
    }
  }
}
