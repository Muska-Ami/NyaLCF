/// 隧道信息模型
/// [name] 隧道名
/// [useCompression] 是否使用压缩
/// [localIP] 本地 IP
/// [node] 节点 ID
/// [localPort] 本地端口
/// [remotePort] 远程端口
/// [domain] 绑定域名
/// [icp] 备案状态
/// [secretKey]
/// [id] 隧道 ID
/// [proxyType] 隧道类型
/// [useEncryption] 是否使用加密
/// [status] 隧道状态
class ProxyInfoModel {
  ProxyInfoModel({
    required this.id,
    required this.name,
    required this.node,
    required this.proxyType,
    required this.localIP,
    required this.localPort,
    required this.remotePort,
    required this.domain,
    required this.secretKey,
    required this.useCompression,
    required this.useEncryption,
    required this.status,
  });

  final String name;
  final bool useCompression;
  final String localIP;
  final int node;
  final int localPort;
  final int? remotePort;
  final String? domain;
  final String? secretKey;
  final int id;
  final String proxyType;
  final bool useEncryption;
  final String? status;

  @override
  String toString() {
    return '$proxyType:$name:$id';
  }
}
