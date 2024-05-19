class UpdateInfoModel {
  UpdateInfoModel({
    required this.version,
    required this.tag,
    required this.buildNumber,
    required this.downloadUrl,
  });

  final String version;
  final String tag;
  final String buildNumber;
  final List<dynamic> downloadUrl;
}
