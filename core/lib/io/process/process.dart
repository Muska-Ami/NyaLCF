import 'dart:io' as io;

class FrpClientProcess {
  final io.Process process;
  final num tunnelId;

  FrpClientProcess({
    required this.process,
    required this.tunnelId,
    Function(FrpClientProcess, int)? onExit,
  }) {
    process.exitCode.then((exitCode) => onExit?.call(this, exitCode));
  }

}