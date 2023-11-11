import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';

class LoginReq {
  var token = null;

  final dio = Dio();

  Future<bool> requestLogin(user, password) async {
    FormData data = FormData.fromMap({"username": user, "password": password});
    try {
      print("Post login: ${user} / ${password}");
      final response =
          await dio.post("${basicConfig.api_v2_url}/users/login", data: data);
      Map<String, dynamic> responseJson = response.data;
      print(responseJson);
      if (responseJson["msg"] == "success") {
        token = responseJson["data"]["token"];
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      return false;
    }
  }
}
