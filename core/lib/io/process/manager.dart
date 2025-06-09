import 'dart:convert';
import 'dart:io' as io;

import 'package:core/io/process/process.dart';

class ProcessManager {
  final _processes = <FrpClientProcess>[];

  final _afterStartHooks = <Function(FrpClientProcess)>[];
  final _beforeKillHooks = <bool Function(FrpClientProcess)>[];
  final _afterExitHooks = <Function()>[];

  final _onStdLogHooks = <Function(String message)>[];
  final _onStdErrLogHooks = <Function(String message)>[];

  Future<FrpClientProcess> run(String executablePath, String? frpToken,
      {required num tunnelId, String? configPath}) async {
    const args = <String>[];
    if (frpToken != null) {
      args.add("-u");
      args.add(frpToken);
      args.add("-p");
      args.add(tunnelId.toString());
    } else if (configPath != null) {
      args.add("-c");
      args.add(configPath);
    } else {
      throw UnsupportedError(
          "Please provide at least one processable data to run a new client.");
    }

    io.Process process = await io.Process.start(executablePath, args);

    FrpClientProcess wrappedProcess = FrpClientProcess(
      process: process,
      tunnelId: tunnelId,
      onExit: _onProcessExit,
    );
    _add(wrappedProcess);

    await _runHookFunction(_afterStartHooks, hasResult: false);

    return wrappedProcess;
  }

  Future<void> kill(FrpClientProcess process) async {
    if (!_processes.contains(process)) {
      throw UnsupportedError("Not a managed process.");
    }

    if ((await _runHookFunction(_beforeKillHooks, hasResult: false))!) return;

    // Kill process
    process.process.kill();
    _remove(process);

    await _runHookFunction(_afterExitHooks, hasResult: false);
  }

  Future<void> killAll() async {
    for (var process in [..._processes]) {
      await kill(process);
    }
  }

  void _add(FrpClientProcess process) {
    _processes.add(process);
    process.process.stdout.forEach((element) async => await _runHookFunction(
          _onStdLogHooks,
          hasResult: false,
        ));
    process.process.stderr.forEach((element) async => await _runHookFunction(
          _onStdErrLogHooks,
          hasResult: false,
        ));
  }

  void _remove(FrpClientProcess process) => _processes.remove(process);

  void _onProcessExit(FrpClientProcess process, int exitCode) async {
    _remove(process);
    await _runHookFunction(_afterExitHooks, hasResult: false);
  }

  /// 注册运行钩子
  /// [hook] 钩子函数
  void registerAfterStartHook(Function(FrpClientProcess) hook) =>
      _afterStartHooks.add(hook);

  /// 注册杀死进程前钩子
  /// [hook] 钩子函数
  void registerBeforeKillHook(bool Function(FrpClientProcess) hook) =>
      _beforeKillHooks.add(hook);

  /// 注册进程退出钩子
  /// [hook] 钩子函数
  void registerAfterExitHook(Function() hook) => _afterExitHooks.add(hook);

  /// 注册标准输出日志钩子
  /// [hook] 钩子函数
  void registerStdLogHook(Function(String message) hook) =>
      _onStdLogHooks.add(hook);

  /// 注册标准错误输出日志钩子
  /// [hook] 钩子函数
  void registerStdErrLogHook(Function(String message) hook) =>
      _onStdErrLogHooks.add(hook);

  Future<bool?> _runHookFunction(List<Function> hooks,
      {required bool hasResult}) async {
    for (var it in hooks) {
      final exec = await it.call();
      if (hasResult && !exec) return exec;
    }
    return null;
  }
}
