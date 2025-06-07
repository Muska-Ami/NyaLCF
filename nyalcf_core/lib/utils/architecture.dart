// Dart imports:
import 'dart:io';

/// 从GitHub Gists复制和修改
/// https://gist.github.com/corbindavenport/d04085e2ac42da303efbaccaa717f223
class Architecture {
  /// 获取当前CPU架构
  static Future<ArchitectureType> getCPUArchitecture() async {
    String? cpu;
    if (Platform.isWindows) {
      cpu = Platform.environment['PROCESSOR_ARCHITECTURE'];
      // var cpu = envVars['PROCESSOR_ARCHITECTURE'];
    } else {
      var info = await Process.run('uname', ['-m']);
      cpu = info.stdout.toString().replaceAll('\n', '');
    }
    switch (cpu?.toLowerCase()) {
      case 'x86_64':
      case'x64':
      case'amd64':
        return ArchitectureType.x86_64;
      case 'x86':
      case'i386':
      case'x32':
      case'386':
      case 'amd32':
        return ArchitectureType.x86;
    }
    return ArchitectureType.unknown;
  }
}

enum ArchitectureType {
  x86_64,
  x86,
  unknown
}
