// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core_extend/storages/token_storage.dart';
import 'package:nyalcf_core_extend/utils/frpc/process_manager.dart';

// Project imports:
import 'package:nyalcf/state.dart';
import 'package:nyalcf/templates/command.dart';

class Start implements Command {
  static final _fcs = FrpcConfigurationStorage();
  static final _tokenStorage = TokenStorage();

  @override
  Future<void> main(List<String> args) async {
    if (args.isNotEmpty) {
      final user = await userInfo;
      if (_tokenStorage.getFrpToken() == null) {
        Logger.error('No frp token found, please do authorize first.');
        exit(0);
      }
      if (user == null) {
        Logger.error('No valid arguments provided.');
        exit(0);
      }
      for (var proxyId in args) {
        final frpcPath = await FrpcStorage().getFilePath(skipCheck: false);
        final runPath =
            await FrpcStorage().getRunPath(_fcs.getSettingsFrpcVersion());

        if (frpcPath != null) {
          final process = await ProcessManager.newProcess(
            frpcPath: frpcPath,
            runPath: runPath,
            frpToken: _tokenStorage.getFrpToken()!,
            proxyId: int.parse(proxyId),
          );
          ProcessManager.addProcess(process);
          Logger.info('Started proxy: $proxyId');
        } else {
          Logger.error('You have no frpc installed yet!');
          exit(0);
        }
      }

      int n = 0;
      ProcessSignal.sigint.watch().listen((signal) {
        n++;
        if (verbose) {
          Logger.verbose('Caught $n of 2');
        }

        Logger.info('Press again to close frpc and exit.');

        Future.delayed(Duration(seconds: 10), () => n = 0);

        if (n == 2) {
          for (var process in ProcessManager.processList) {
            process.process.kill();
          }
          exit(0);
        }
      });
    } else {
      Logger.error('No user info, please do authorize first.');
    }
  }
}
