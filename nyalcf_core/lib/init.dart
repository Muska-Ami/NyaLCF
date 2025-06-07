class Init {
  static late final Version _version;

  static late final String _cachePath;
  static late final String _supportPath;

  static void setVersion(Version ver) => _version = ver;
  static void getVersion() => _version;

  static void setCachePath(String cachePath) => _cachePath = cachePath;
  static String getCachePath() => _cachePath;
  static void setSupportPath(String supportPath) => _supportPath = supportPath;
  static String getSupportPath() => _supportPath;

}

class Version {
  final String version;
  final int buildNumber;

  Version({
    required this.version,
    required this.buildNumber,
  });
}
