import 'package:nyalcf_core/network/dio/frpc/frpc.dart';

void main() async {
  final res = await VersionFrpc.getLatestVersion();
  if (res.status) {
    print(res.data['latest_version']);
  } else {
    throw res.data['error'];
  }
}
