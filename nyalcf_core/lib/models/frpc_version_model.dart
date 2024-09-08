/// Frpc版本模型
/// [releaseName] Release 名称
/// [tagName] Release Tag
class FrpcVersionModel {
  FrpcVersionModel({
    required this.releaseName,
    required this.tagName,
  });

  final String releaseName;
  final String tagName;
}
