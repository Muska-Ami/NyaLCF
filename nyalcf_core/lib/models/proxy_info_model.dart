/// 隧道信息模型
/// [proxyName] 隧道名
/// [useCompression] 是否使用压缩
/// [localIP] 本地 IP
/// [node] 节点 ID
/// [localPort] 本地端口
/// [remotePort] 远程端口
/// [domain] 绑定域名
/// [icp] 备案状态
/// [sk]
/// [id] 隧道 ID
/// [proxyType] 隧道类型
/// [useEncryption] 是否使用加密
/// [status] 隧道状态
class ProxyInfoModel {
  ProxyInfoModel({
    required this.proxyName,
    required this.useCompression,
    required this.localIP,
    required this.node,
    required this.localPort,
    required this.remotePort,
    required this.domain,
    required this.icp,
    required this.sk,
    required this.id,
    required this.proxyType,
    required this.useEncryption,
    required this.status,
  });

  final String proxyName;
  final bool useCompression;
  final String localIP;
  final int node;
  final int localPort;
  final int remotePort;
  final String? domain;
  final String? icp;
  final String? sk;
  final int id;
  final String proxyType;
  final bool useEncryption;
  final String? status;

  @override
  String toString() {
    return '$proxyType:$proxyName:$id';
  }
}
