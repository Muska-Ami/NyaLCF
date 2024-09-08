import 'dart:io';

import 'package:logger/logger.dart' as log_u;

import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger/file_output.dart';
import 'package:nyalcf_core/utils/logger/log_printer.dart';
import 'package:nyalcf_core/utils/logger/frpc_printer.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

class Logger {
  static final String? _supportPath = appSupportPath;
  static final _lcs = LauncherConfigurationStorage();

  static get _fileOutPut async =>
      FileOutput(file: File('$_supportPath/logs/run.log'));
  static get _frpcOutPut async =>
      FileOutput(file: File('$_supportPath/logs/frpc.log'));
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
  static get _logger async {
    List<log_u.LogOutput> multiOutput = [_consoleOutput, await _fileOutPut];
    return log_u.Logger(
      filter: LogFilter(),
      printer: LogPrinter(),
      output: log_u.MultiOutput(multiOutput),
    );
  }

  /// 获取 Frpc Logger 对象
  static get _frpcLogger async {
    List<log_u.LogOutput> multiOutput = [_consoleOutput, await _frpcOutPut];
    return log_u.Logger(
      filter: LogFilter(),
      printer: FrpcPrinter(),
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
      sb.write('${s.toString()}\n');
      if (t != null) {
        sb.write('Trace:\n');
        sb.write(t);
      }
    } else {
      sb.write(s);
    }
    (await _logger).e(sb.toString());
  }

  /// VERBOSE
  /// 基本上没用，被 DEBUG 替代了
  static Future<void> verbose(s) async {
    (await _logger).v(s);
  }

  /// DEBUG
  static Future<void> debug(s) async {
    if (_lcs.getDebug()) {
      (await _logger).d(s);
    }
  }

  /// FRPC INFO
  static Future<void> frpcInfo(pxid, s) async {
    (await _frpcLogger).i('[$pxid] $s');
  }

  /// FRPC WARN
  static Future<void> frpcWarn(pxid, s) async {
    (await _frpcLogger).w('[$pxid] $s');
  }

  /// FRPC ERROR
  static Future<void> frpcError(pxid, s) async {
    (await _frpcLogger).e('[$pxid] $s');
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
