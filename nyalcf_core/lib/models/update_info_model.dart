class UpdateInfoModel {
  UpdateInfoModel({
    required this.version,
    required this.tag,
    required this.downloadUrl,
  });

  final String version;
  final String tag;
  final List<dynamic> downloadUrl;
}
