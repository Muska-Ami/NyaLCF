import 'package:dio/dio.dart';

import '../../model/User.dart';
import '../basicConfig.dart';

class RegisterDio {
  final dio = Dio();

  Future<dynamic> requestRegister(
    user,
    password,
    confirmPassword,
    email,
    verify,
    qq
  ) async {
    FormData data = FormData.fromMap({
      'username': user,
      'password': password,
      'confirm_password': confirmPassword,
      'email': email,
      'verify': verify,
      'qq': qq,
    });
    try {
      print('Post register: ${user} - ${email} / ${password} - ${confirmPassword}');
      final response =
          await dio.post('${basicConfig.api_v2_url}/users/login', data: data);
      Map<String, dynamic> responseJson = response.data;
      print(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        final userInfo = User(
            user: resData['username'],
            email: resData['email'],
            token: resData['token'],
            avatar: resData['avatar'],
            inbound: resData['inbound'],
            outbound: resData['outbound'],
            frp_token: resData['frp_token'],
            traffic: resData['traffic']);
        return userInfo;
      } else {
        return resData['msg'] ?? responseJson['status'];
      }
    } catch (ex) {
      print(ex);
      return ex;
    }
  }

  Future<dynamic> requestCode(email) async {
    try {
      print('Requesting email code, email: ${email}');
      Map<String, dynamic> params_map = Map();
      params_map['email'] = email;
      final response = await dio.get(
        '${basicConfig.api_v2_url}/users/send',
        queryParameters: params_map,
      );
      final resData = response.data;
      if (resData['msg'] == 'success')
        return true;
      else
        return resData['msg'];
    } catch (ex) {
      print(ex);
      return ex;
    }
  }
}
