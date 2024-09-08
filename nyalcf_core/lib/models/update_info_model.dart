/// 启动器更新信息模型
/// [version] 版本号
/// [tag] 版本标签
/// [buildNumber] 版本构建号
/// [downloadUrl] 资源列表
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
