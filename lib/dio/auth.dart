import 'package:dio/dio.dart';
import 'package:nyalcf/dio/basicConfig.dart';

import '../model/UserInfo.dart';

class Auth {
  final dio = Dio();

  Future<dynamic> requestLogin(user, password) async {
    FormData data = FormData.fromMap({"username": user, "password": password});
    try {
      print("Post login: ${user} / ${password}");
      final response =
          await dio.post("${basicConfig.api_v2_url}/users/login", data: data);
      Map<String, dynamic> responseJson = response.data;
      print(responseJson);
      final resData = responseJson["data"];
      if (responseJson["status"] == 200) {
        final userInfo = UserInfo(
            user: resData["username"],
            email: resData["email"],
            token: resData["token"],
            avatar: resData["avatar"]);
        return userInfo;
      } else {
        return resData["msg"] ?? responseJson["status"];
      }
    } catch (ex) {
      print(ex);
      return ex;
    }
  }
}
