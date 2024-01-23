import 'dart:io';

import 'package:logger/logger.dart' as LoU;
import 'package:nyalcf/util/FileIO.dart';

class Logger {
  static Future<String> _s_path = FileIO.support_path;
  static get _fileOutPut async =>
      LoU.FileOutput(file: File('${await _s_path}/run.log'));
  static LoU.ConsoleOutput _consoleOutput = LoU.ConsoleOutput();

  static get _logger async {
    List<LoU.LogOutput> multiOutput = [await _fileOutPut, await _consoleOutput];
    return await LoU.Logger(
      printer: LoU.HybridPrinter(
        LoU.PrettyPrinter(
          printEmojis: false,
          printTime: true,
        ),
        debug: LoU.PrettyPrinter(
          printEmojis: false,
          printTime: true,
            levelColors: {
              LoU.Level.debug: LoU.AnsiColor.fg(126)
            }
        )
      ),
      output: LoU.MultiOutput(
        multiOutput,
      ),
    );
  }

  static Future<void> info(s) async {
    (await _logger).i(s);
  }

  static Future<void> warn(s) async {
    (await _logger).w(s);
  }

  static Future<void> error(s) async {
    (await _logger).e(s);
  }

  static Future<void> verbose(s) async {
    (await _logger).v(s);
  }

  static Future<void> debug(s) async {
    (await _logger).d(s);
  }

  static Future<void> frpc_info(s) async {
    await info('[FRPC][INFO]$s');
  }

  static Future<void> frpc_warn(s) async {
    await warn('[FRPC][WARN]$s');
  }

  static Future<void> frpc_error(s) async {
    await error('[FRPC][ERROR]$s');
  }
}
