/// Frpc 版本列表模型
@deprecated
class FrpcListModel {
  FrpcListModel({
    required this.name,
    required this.description,
    required this.assets,
  });

  /// 版本名
  final String name;
  /// 版本介绍
  final String description;
  /// 资源列表
  final List<Map<String, dynamic>> assets;
}
