import 'dart:io';

/// 进程模型
class ProcessModel {
  ProcessModel({
    required this.proxyId,
    required this.process,
  });

  /// 隧道ID
  final int proxyId;
  /// 进程对象
  final Process process;

  @override
  String toString() {
    return '[$proxyId] PID: ${process.pid}';
  }
}
