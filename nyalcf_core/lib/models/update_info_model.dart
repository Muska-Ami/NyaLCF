/// 启动器更新信息模型
class UpdateInfoModel {
  UpdateInfoModel({
    required this.version,
    required this.tag,
    required this.buildNumber,
    required this.downloadUrl,
  });

  /// 版本号
  final String version;
  /// 版本标签
  final String tag;
  /// 版本构建号
  final String buildNumber;
  /// 资源列表
  final List<dynamic> downloadUrl;
}
