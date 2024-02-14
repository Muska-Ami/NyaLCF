import 'package:dio/dio.dart';
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/models/user_info_model.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';

class LoginAuth {
  final dio = Dio();

  Future<dynamic> requestLogin(user, password) async {
    FormData data = FormData.fromMap({'username': user, 'password': password});
    try {
      Logger.debug('Post login: $user / $password');
      final response = await dio
          .post('${BasicDioConfig.api_v2_url}/users/login', data: data);
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
            frpToken: resData['frp_token'],
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
