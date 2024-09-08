import 'dart:io';

/// 进程模型
/// [proxyId] 绑定的隧道 ID
/// [process] 进程对象
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
