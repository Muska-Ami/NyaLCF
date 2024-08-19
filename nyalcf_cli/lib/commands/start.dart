import 'dart:io';

import 'package:nyalcf/utils/frpc/process_manager.dart';
import 'package:nyalcf/utils/state.dart';
import 'package:nyalcf/templates/command_implement.dart';
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
            final process = await ProcessManager.newProcess(
              frpcPath: frpcPath,
              runPath: runPath,
              frpToken: user.frpToken,
              proxyId: int.parse(proxyId),
            );
            ProcessManager.addProcess(process);
            Logger.info('Started proxy: $proxyId');
          } else {
            Logger.error('You have no frpc installed yet!');
          }
        }

        int n = 0;
        ProcessSignal.sigint.watch().listen((signal) {
          if (verbose) {
            Logger.verbose('Caught ${++n} of 2');
            Logger.info('Press again to close frpc and exit.');
          }

          if (n == 2) {
            for (var process in ProcessManager.processList) {
              process.process.kill();
            }
            exit(0);
          }
        });
      } else {
        Logger.error('You have no login session yet!');
      }
    } else {
      Logger.error('No valid arguments provided.');
    }
  }
}
