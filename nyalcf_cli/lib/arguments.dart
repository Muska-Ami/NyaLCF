import 'package:args/args.dart';

class Arguments {
  static ArgParser get all => ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'login',
      abbr: 'l',
      negatable: false,
      help: 'Login to LoCyanFrp.',
    )
    ..addFlag(
      'config',
      abbr: 'c',
      negatable: false,
      help: 'Modify Nya LoCyanFrp! CLI configuration.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}
