// // Project imports:
// import 'package:nyalcf_core/models/response/response.dart';
// import 'package:nyalcf_core/network/client/frpc/frpc.dart';
//
// void main() async {
//   final res = await VersionFrpc.getLatestVersion();
//   if (res.status) {
//     res as FrpcSingleVersionResponse;
//     print(res.version.tagName);
//   } else {
//     res as ErrorResponse;
//     res.exception != null ? throw res.exception! : throw Exception(res.message);
//   }
// }
