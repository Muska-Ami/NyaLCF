// Dart imports:
import 'dart:io';

// Package imports:
import 'package:logger/logger.dart' as log_u;
import 'package:core/init.dart';

// Project imports:
import 'package:core/storages/configurations/launcher_configuration_storage.dart';
import 'package:core/utils/logger/file_output.dart';
import 'package:core/utils/logger/log_printer.dart';

class FrpcLogger {
  int tunnelId;

  FrpcLogger({
    required this.tunnelId,
  });

  final String _supportPath = Init.getSupportPath();
  final _lcs = LauncherConfigurationStorage();

  get _fileOutput async => FileOutput(
    file: File('$_supportPath/logs/frpc/$tunnelId.log'),
  );
  final log_u.ConsoleOutput _consoleOutput = log_u.ConsoleOutput();

  /// 初始化
  init() {
    final dir = Directory("$_supportPath/logs");
    if (!dir.existsSync()) dir.createSync();
  }

  /// 重置日志文件
  clear() async {
    final dir = Directory(('$_supportPath/logs'));
    if (await dir.exists()) await dir.delete();
  }

  /// 获取 Logger 对象
  Future<log_u.Logger> get _logger async {
    List<log_u.LogOutput> multiOutput = [_consoleOutput, await _fileOutput];
    return log_u.Logger(
      filter: LogFilter(),
      printer: LogPrinter(),
      output: log_u.MultiOutput(multiOutput),
    );
  }

  /// INFO
  Future<void> info(s) async {
    (await _logger).i(s);
  }

  /// WARN
  Future<void> warn(s) async {
    (await _logger).w(s);
  }

  /// ERROR
  Future<void> error(s, {StackTrace? t}) async {
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

  /// DEBUG
  Future<void> debug(s) async {
    if (_lcs.getDebug()) {
      (await _logger).d(s);
    }
  }

  Future<void> write(s) async {
    stdout.write('\r${' ' * 30}');
    stdout.write('\r$s');
  }
}

class LogFilter extends log_u.LogFilter {
  @override
  bool shouldLog(log_u.LogEvent event) {
    return true;
  }
}
