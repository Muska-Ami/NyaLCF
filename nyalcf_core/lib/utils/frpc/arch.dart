class Arch {
  static List<Map<String, String>> windows = [
    {'arch': 'amd64', 'name': 'x86_64/amd64'},
    {'arch': '386', 'name': 'x86/i386/amd32'},
    {'arch': 'arm64', 'name': 'arm64/armv8'},
  ];
  static List<Map<String, String>> linux = [
    {'arch': 'amd64', 'name': 'x86_64/amd64'},
    {'arch': '386', 'name': 'x86/i386/amd32'},
    {'arch': 'arm64', 'name': 'arm64/armv8'},
    {'arch': 'arm', 'name': 'arm/armv7/armv6/armv5'},
    {'arch': 'mips64', 'name': 'mips64'},
    {'arch': 'mips', 'name': 'mips'},
    {'arch': 'mips64le', 'name': 'mips64le'},
    {'arch': 'mipsle', 'name': 'mipsle'},
    {'arch': 'riscv64', 'name': 'riscv64'},
  ];
  static List<Map<String, String>> macos = [
    {'arch': 'amd64', 'name': 'x86_64/amd64'},
    {'arch': 'arm64', 'name': 'arm64/armv8'},
  ];
}