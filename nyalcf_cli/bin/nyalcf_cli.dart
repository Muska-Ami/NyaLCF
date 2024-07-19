import 'dart:io';

import 'package:args/args.dart';
import 'package:nyalcf/actions/config.dart';
import 'package:nyalcf/actions/login.dart';
import 'package:nyalcf/arguments.dart';
import 'package:nyalcf/utils/path_provider.dart';
import 'package:nyalcf/utils/state.dart';
import 'package:nyalcf_core/storages/injector.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

final version = '0.1.0';

ArgParser buildParser() {
  return Arguments.all;
}

void printUsage(ArgParser argParser) {
  Logger.info('Usage: dart nyalcf_cli.dart <flags> [arguments]');
  Logger.info(argParser.usage.split('\n'));
}

void main(List<String> arguments) async {
  /// 加载环境
  setAppendInfo('CLI v$version an=${Platform.executable}');

  /// 初始化配置文件等
  await PathProvider.loadPath();
  await StoragesInjector.init();
  await Logger.init();

  Logger.debug('Append info has been set: $appendInfo');

  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    // bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }

    if (results.wasParsed('login')) {
      Login().main(results.rest);
    }

    if (results.wasParsed('version')) {
      Logger.info('Nya LoCyanFrp! CLI version: $version');
      return;
    }
    if (results.wasParsed('config')) {
      Config().main(results.rest);
    }

    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    if (verbose) {
      Logger.verbose('All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    Logger.error(e);
    printUsage(argParser);
  }
}
