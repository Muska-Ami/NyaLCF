import 'dart:io';

import 'package:logger/logger.dart' as LoU;
import 'package:nyalcf/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf/utils/path_provider.dart';

class Logger {
  static final String? _supportPath = PathProvider.appSupportPath;
  static final lcs = LauncherConfigurationStorage();

  static get _fileOutPut async =>
      LoU.FileOutput(file: File('$_supportPath/run.log'));
  static final LoU.ConsoleOutput _consoleOutput = LoU.ConsoleOutput();

  /// 重置日志文件
  static clear() async {
    final file = File(('$_supportPath/run.log'));
    if (await file.exists()) await file.delete();
  }

  static get _logger async {
    List<LoU.LogOutput> multiOutput = [await _fileOutPut, _consoleOutput];
    return LoU.Logger(
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
            LoU.Level.debug: const LoU.AnsiColor.fg(126),
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
    if (lcs.getDebug()) {
      (await _logger).d(s);
    }
  }

  static Future<void> frpcInfo(s) async {
    await info('[FRPC][INFO]$s');
  }

  static Future<void> frpcWarn(s) async {
    await warn('[FRPC][WARN]$s');
  }

  static Future<void> frpcError(s) async {
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
  bool shouldLog(LoU.LogEvent event) {
    return true;
  }
}
