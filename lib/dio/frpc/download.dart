import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';
import 'package:nyalcf/model/FrpcList.dart';
import 'package:nyalcf/util/FileIO.dart';
import 'package:path_provider/path_provider.dart';

class FrpcDownloadDio {
  final dio = Dio();

  /*
  Future<FrpcList> fetchVersion() async {
    final response =
        await dio.get("${basicConfig.github_api_url}/repos/${basicConfig.frpc_release_repo}/releases/latest");
    
  }
   */

  Future<dynamic> download(
      {required String arch,
      required String platform,
      required ProgressCallback progressCallback,
      required CancelToken cancelToken}) async {
    try {
      return await dio.download(
          "https://github.com/LoCyan-Team/LoCyanFrpPureApp/releases/download/v0.51.3/frp_LoCyanFrp-0.51.3_windows_amd64.zip",
          "${FileIO().cache_path}/",
          cancelToken: cancelToken,
          onReceiveProgress: progressCallback);
    } on DioException catch (e) {
      if (cancelToken.isCancelled)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }
}
