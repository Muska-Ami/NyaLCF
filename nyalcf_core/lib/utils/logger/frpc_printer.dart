// Package imports:
import 'package:logger/logger.dart' as log_u;

class FrpcPrinter extends log_u.LogPrinter {
  static const rstColor = log_u.AnsiColor.ansiDefault;
  static const timeColor = log_u.AnsiColor.fg(123);
  static const dataColor = log_u.AnsiColor.fg(120);
  static const frpcColor = log_u.AnsiColor.fg(220);

  static final levelPrefixes = {
    log_u.Level.trace: 'TRACE',
    log_u.Level.debug: 'DEBUG',
    log_u.Level.info: 'INFO',
    log_u.Level.warning: 'WARN',
    log_u.Level.error: 'ERROR',
    log_u.Level.fatal: 'FATAL',
  };
  static final Map<log_u.Level, log_u.AnsiColor> defaultLevelColors = {
    log_u.Level.trace: log_u.AnsiColor.fg(log_u.AnsiColor.grey(0.5)),
    log_u.Level.debug: const log_u.AnsiColor.fg(126),
    log_u.Level.info: const log_u.AnsiColor.fg(12),
    log_u.Level.warning: const log_u.AnsiColor.fg(220),
    log_u.Level.error: const log_u.AnsiColor.fg(196),
    log_u.Level.fatal: const log_u.AnsiColor.fg(199),
  };

  @override
  List<String> log(log_u.LogEvent event) {
    StringBuffer output = StringBuffer();

    DateTime time = DateTime.now();
    String level = levelPrefixes[event.level] ?? 'UNKNOWN';
    log_u.AnsiColor levelColor = _getLevelColor(event.level);
    dynamic message = event.message;
    String prefix =
        '[$timeColor$time$rstColor][${frpcColor}FPRC$rstColor][$levelColor$level$rstColor]: ${(event.level == log_u.Level.warning) || (event.level == log_u.Level.error) ? levelColor : rstColor}';

    output.write('$prefix$message$rstColor');
    if (event.error != null) {
      output.write('${prefix}ERR: ${event.error}$rstColor');
    }

    return [output.toString()];
  }

  dynamic _getLevelColor(log_u.Level level) {
    log_u.AnsiColor? color;
    color = defaultLevelColors[level];
    return color ?? rstColor;
  }
}
