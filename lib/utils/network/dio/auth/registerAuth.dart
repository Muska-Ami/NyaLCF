import 'package:dio/dio.dart';
import 'package:nyalcf/utils/Logger.dart';

import 'package:nyalcf/utils/network/dio/basicConfig.dart';

class RegisterAuth {
  final dio = Dio();

  Future<dynamic> requestRegister(
      user, password, confirmPassword, email, verify, qq) async {
    FormData data = FormData.fromMap({
      'username': user,
      'password': password,
      'confirm_password': confirmPassword,
      'email': email,
      'verify': verify,
      'qq': qq,
    });
    try {
      Logger.debug(
          'Post register: ${user} - ${email} / ${password} - ${confirmPassword} / ${verify}');
      final response = await dio
          .post('${basicConfig.api_v2_url}/users/register', data: data);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        return true;
      } else {
        return resData['msg'] ?? responseJson['status'];
      }
    } catch (ex) {
      Logger.error(ex);
      return ex;
    }
  }

  Future<dynamic> requestCode(email) async {
    try {
      Logger.debug('Requesting email code, email: ${email}');
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
      Logger.error(ex);
      return ex;
    }
  }
}
