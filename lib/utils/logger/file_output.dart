import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';

class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  static final defaultLevelColors = [
    AnsiColor.ansiDefault,
    AnsiColor.fg(AnsiColor.grey(0.5)),
    const AnsiColor.fg(126),
    const AnsiColor.fg(12),
    const AnsiColor.fg(220),
    const AnsiColor.fg(196),
    const AnsiColor.fg(199),
    const AnsiColor.fg(123),
  ];

  FileOutput({
    required this.file,
    this.overrideExisting = true,
    this.encoding = utf8,
  });

  @override
  Future<void> init() async {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(_removeAnsiEscapeCodes(event.lines), '\n');
    _sink?.writeln();
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }

  List<String> _removeAnsiEscapeCodes(List<String> input) {
    List<String> output = [];
    for (var log in input) {
      String str = log;
      for (var color in defaultLevelColors) {
        str = str.replaceAll(color.toString(), '');
      }
      output.add(str);
    }
    return output;
  }
}
