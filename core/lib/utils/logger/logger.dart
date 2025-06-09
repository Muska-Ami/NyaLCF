// Dart imports:
import 'dart:io';

// Package imports:
import 'package:logger/logger.dart' as log_u;
import 'package:core/init.dart';

// Project imports:
import 'package:core/storages/configurations/launcher_configuration_storage.dart';
import 'package:core/utils/logger/file_output.dart';
import 'package:core/utils/logger/log_printer.dart';

class Logger {
  static final String _supportPath = Init.getSupportPath();
  static final _lcs = LauncherConfigurationStorage();

  static get _fileOutput async => FileOutput(
      file: File('$_supportPath/logs/run.log'),
  );
  static final log_u.ConsoleOutput _consoleOutput = log_u.ConsoleOutput();

  /// 初始化
  static init() {
    final dir = Directory("$_supportPath/logs");
    if (!dir.existsSync()) dir.createSync();
  }

  /// 重置日志文件
  static clear() async {
    final dir = Directory(('$_supportPath/logs'));
    if (await dir.exists()) await dir.delete();
  }

  /// 获取 Logger 对象
  static Future<log_u.Logger> get _logger async {
    List<log_u.LogOutput> multiOutput = [_consoleOutput, await _fileOutput];
    return log_u.Logger(
      filter: LogFilter(),
      printer: LogPrinter(),
      output: log_u.MultiOutput(multiOutput),
    );
  }

  /// INFO
  static Future<void> info(s) async {
    (await _logger).i(s);
  }

  /// WARN
  static Future<void> warn(s) async {
    (await _logger).w(s);
  }

  /// ERROR
  static Future<void> error(s, {StackTrace? t}) async {
    final sb = StringBuffer();
    if (s is Exception) {
      sb.write(s.toString());
    } else {
      sb.write(s);
    }
    if (t != null) {
      sb.write('\nTrace:\n');
      sb.write(t);
    }
    (await _logger).e(sb.toString());
  }

  /// VERBOSE
  /// 基本上没用，被 DEBUG 替代了
  static Future<void> verbose(s) async {
    (await _logger).t(s);
  }

  /// DEBUG
  static Future<void> debug(s) async {
    if (_lcs.getDebug()) {
      (await _logger).d(s);
    }
  }

  static Future<void> write(s) async {
    stdout.write('\r${' ' * 30}');
    stdout.write('\r$s');
  }

  /// 覆盖 GetX 默认 Logger
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
