import 'dart:io';

import 'package:logger/logger.dart' as log_u;
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger/file_output.dart';
import 'package:nyalcf_core/utils/logger/log_printer.dart';
import 'package:nyalcf_core/utils/path_provider.dart';

class Logger {
  static final String? _supportPath = PathProvider.appSupportPath;
  static final _lcs = LauncherConfigurationStorage();

  static get _fileOutPut async =>
      FileOutput(file: File('$_supportPath/run.log'));
  static final log_u.ConsoleOutput _consoleOutput = log_u.ConsoleOutput();

  /// 重置日志文件
  static clear() async {
    final file = File(('$_supportPath/run.log'));
    if (await file.exists()) await file.delete();
  }

  static get _logger async {
    List<log_u.LogOutput> multiOutput = [await _fileOutPut, _consoleOutput];
    return log_u.Logger(
      filter: LogFilter(),
      printer: LogPrinter(),
      output: log_u.MultiOutput(multiOutput),
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
    if (_lcs.getDebug()) {
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

class LogFilter extends log_u.LogFilter {
  @override
  bool shouldLog(log_u.LogEvent event) {
    return true;
  }
}
