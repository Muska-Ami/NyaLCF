import 'dart:io';

class ProcessModel {
  ProcessModel({
    required this.proxyId,
    required this.process,
  });
  final int proxyId;
  final Process process;

  @override
  String toString() {
    return '[$proxyId] PID: ${process.pid}';
  }
}
