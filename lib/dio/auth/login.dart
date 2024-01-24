import 'package:dio/dio.dart';
import 'package:nyalcf/util/Logger.dart';

import '../../model/UserInfoModel.dart';
import '../basicConfig.dart';

class LoginDio {
  final dio = Dio();

  Future<dynamic> requestLogin(user, password) async {
    FormData data = FormData.fromMap({'username': user, 'password': password});
    try {
      Logger.debug('Post login: ${user} / ${password}');
      final response =
          await dio.post('${basicConfig.api_v2_url}/users/login', data: data);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        final userInfo = UserInfoModel(
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
      Logger.error(ex);
      return ex;
    }
  }
}
