import 'package:nyalcf/utils/template/command_implement.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

import 'package:nyalcf/utils/state.dart';

class Config implements CommandImplement {
  @override
  bool result = false;

  @override
  bool end() {
    return result;
  }

  final _lcs = LauncherConfigurationStorage();

  @override
  void main(List<String> args) {
    if (verbose) {
      Logger.verbose(args);
    }
    switch (args[0]) {
      case 'launcher':
        if (args.length == 3) {
          final originValue = _lcs.cfg.get(args[1]);
          final convertedValue = _convert(originValue, args[2]);
          if (convertedValue != null) {
            _lcs.cfg.set(args[1], convertedValue);
            _lcs.save();
            Logger.info('Node "${args[1]}" has been set to: "${args[2]}"');
          } else {
            Logger.error(
                'Could not set ${args[1]} to ${args[2]}: could not automatic convert type to origin type, please edit the configuration manually');
          }
        }
        break;
      default:
        Logger.error('Invalid configuration provided!');
        Logger.error('Expected: launcher');
    }
  }

  dynamic _convert(dynamic originValue, String input) {
    switch (originValue.runtimeType) {
      case int:
        return int.parse(input);
      case double:
        return double.parse(input);
      case bool:
        return bool.parse(input);
      case String:
        return input;
      default:
        return null;
    }
  }
}
