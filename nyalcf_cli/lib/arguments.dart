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
      help: 'Login to LoCyanFrp. usage: <username> <password>',
    )
    ..addFlag(
      'logout',
      negatable: false,
      help: 'Logout to LoCyanFrp.',
    )
    ..addFlag(
      'config',
      abbr: 'c',
      negatable: false,
      help:
          'Modify Nya LoCyanFrp! CLI configuration. usage: <configuration> <node> <value>',
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
