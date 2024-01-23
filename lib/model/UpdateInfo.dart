class UpdateInfo {
  UpdateInfo({
    required this.version,
    required this.tag,
    required this.download_url,
  });

  final String version;
  final String tag;
  final List<dynamic> download_url;
}