// // Project imports:
// import 'package:core/models/response/response.dart';
// import 'package:core/network/client/frpc/frpc.dart';
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
