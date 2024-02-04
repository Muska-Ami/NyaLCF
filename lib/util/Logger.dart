import 'dart:io';

import 'package:logger/logger.dart' as LoU;
import 'package:nyalcf/util/FileIO.dart';

class Logger {
  static Future<String> _s_path = FileIO.support_path;
  static get _fileOutPut async =>
      LoU.FileOutput(file: File('${await _s_path}/run.log'));
  static LoU.ConsoleOutput _consoleOutput = LoU.ConsoleOutput();

  /// 重置日志文件
  static clear() async {
    final file = await File(('${(await _s_path)}/run.log'));
    if (await file.exists()) await file.delete();
  }

  static get _logger async {
    List<LoU.LogOutput> multiOutput = [await _fileOutPut, await _consoleOutput];
    return await LoU.Logger(
      filter: LogFilter(),
      printer: LoU.HybridPrinter(
        LoU.PrettyPrinter(
          printEmojis: false,
          printTime: true,
          methodCount: 0,
          lineLength: 60,
          errorMethodCount: null,
        ),
        debug: LoU.PrettyPrinter(
          printEmojis: false,
          printTime: true,
          lineLength: 60,
          levelColors: {
            LoU.Level.debug: LoU.AnsiColor.fg(126),
          },
          methodCount: 0,
          errorMethodCount: null,
        ),
      ),
      output: LoU.MultiOutput(multiOutput),
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
    // if (debug) {
    (await _logger).d(s);
    // }
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

  static Future<void> getxLogWriter(String text, {bool isError = false}) async {
    if (isError) {
      await error(text);
    } else {
      await info(text);
    }
  }
}

class LogFilter extends LoU.LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
