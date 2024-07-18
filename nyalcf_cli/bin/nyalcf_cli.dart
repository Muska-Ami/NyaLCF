import 'package:args/args.dart';
import 'package:nyalcf_cli/arguments.dart';
import 'package:nyalcf_core/storages/injector.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/path_provider.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

final version = '0.1.0';

ArgParser buildParser() {
  return Arguments.all;
}

void printUsage(ArgParser argParser) {
  print('Usage: dart nyalcf_cli.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  /// 加载环境
  // await Universe.loadUniverse();
  setAppendInfo('CLI v$version');

  /// 初始化配置文件等
  await PathProvider.loadSyncPath();
  await StoragesInjector.init();
  await Logger.init();

  Logger.debug('Append info has been set: $appendInfo');

  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }

    if (results.wasParsed('login')) {

    }

    if (results.wasParsed('version')) {
      TODO: print('Nya LoCyanFrp! CLI version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
