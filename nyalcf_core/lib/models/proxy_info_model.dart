/// 隧道信息模型
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
  final String sk;
  final int id;
  final String proxyType;
  final bool useEncryption;
  final String? status;

  @override
  String toString() {
    return '$proxyType:$proxyName:$id';
  }
}
