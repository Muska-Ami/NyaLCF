// Package imports:
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
      'authorize',
      abbr: 'a',
      negatable: false,
      help: 'Authorize. usage: <username> <password>',
    )
    ..addFlag(
      'logout',
      negatable: false,
      help: 'Logout to LoCyanFrp.',
    )
    ..addFlag(
      'start',
      abbr: 's',
      negatable: false,
      help: 'Start frpc. usage: ..<proxy_id>',
    )
    ..addFlag(
      'download',
      abbr: 'd',
      negatable: false,
      help: 'Download frpc. usage: [<arch> [<platform>]]',
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
