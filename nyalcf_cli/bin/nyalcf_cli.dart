// Dart imports:
import 'dart:io';

// Package imports:
import 'package:args/args.dart';
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/storages/injector.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf/arguments.dart';
import 'package:nyalcf/commands/config.dart';
import 'package:nyalcf/commands/download.dart';
import 'package:nyalcf/commands/login.dart';
import 'package:nyalcf/commands/logout.dart';
import 'package:nyalcf/commands/start.dart';
import 'package:nyalcf/utils/path_provider.dart';
import 'package:nyalcf/utils/state.dart';

final version = '0.0.3';

ArgParser buildParser() {
  return Arguments.all;
}

void printUsage(ArgParser argParser) {
  Logger.info('Usage: dart nyalcf_cli.dart <flags> [arguments]');
  argParser.usage.split('\n').forEach((val) => Logger.info(val));
}

void main(List<String> arguments) async {
  /// 加载环境
  setAppendInfo('CLI v$version an=${Platform.executable}');

  /// 初始化配置文件等
  await PathProvider.loadPath();
  await StoragesInjector.init();
  await Logger.init();

  final lcs = LauncherConfigurationStorage();
  if (lcs.getDebug()) {
    verbose = true;
  }

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

    // 登录登出
    if (results.wasParsed('login')) {
      await Login().main(results.rest);
    }
    if (results.wasParsed('logout')) {
      await Logout().main(results.rest);
    }

    // 启动 Frpc
    if (results.wasParsed('start')) {
      await Start().main(results.rest);
    }

    // 版本信息
    if (results.wasParsed('version')) {
      Logger.info('Nya LoCyanFrp! CLI version: $version');
      return;
    }

    // 下载 Frpc
    if (results.wasParsed('download')) {
      Download().main(results.rest);
    }

    // 配置修改
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
