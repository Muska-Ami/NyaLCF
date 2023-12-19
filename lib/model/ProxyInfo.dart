class ProxyInfo {
  ProxyInfo(
      {required this.proxy_name,
      required this.use_compression,
      required this.local_ip,
      required this.node,
      required this.local_port,
      required this.remote_port,
      required this.domain,
      required this.icp,
      required this.sk,
      required this.id,
      required this.proxy_type,
      required this.use_encryption,
      required this.status});

  final String proxy_name;
  final bool use_compression;
  final String local_ip;
  final int node;
  final int local_port;
  final int remote_port;
  final String domain;
  final String? icp;
  final String sk;
  final int id;
  final String proxy_type;
  final bool use_encryption;
  final status;
}
