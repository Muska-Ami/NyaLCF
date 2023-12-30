import 'dart:io';

/// Copy & modify from GitHub Gists
/// https://gist.github.com/corbindavenport/d04085e2ac42da303efbaccaa717f223
class CPUArch {

  // Function get current CPU architecture
  static Future<String> getCPUArchitecture() async {
    var cpu;
    if (Platform.isWindows) {
      cpu = Platform.environment['PROCESSOR_ARCHITECTURE'];
      // var cpu = envVars['PROCESSOR_ARCHITECTURE'];
    } else {
      var info = await Process.run('uname', ['-m']);
      cpu = info.stdout.toString().replaceAll('\n', '');
    }
    switch (cpu) {
      case 'x86_64' || 'X86_64' || 'x64' || 'X64' || 'AMD64':
        cpu = 'amd64';
        break;
      case 'x86' || 'X86' || 'i386' || 'I386' || 'x32' || 'X32' || '386' || 'AMD32':
        cpu = 'amd32';
        break;
    }
    return cpu;
  }

}