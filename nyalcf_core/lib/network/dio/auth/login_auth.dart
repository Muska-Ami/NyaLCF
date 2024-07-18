import 'package:dio/dio.dart' as dio;

import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/network/dio/basic_config.dart';
import 'package:nyalcf_core/network/response_type.dart';

class LoginAuth {
  final instance = dio.Dio(options);

  Future<Response> requestLogin(user, password) async {
    dio.FormData data =
        dio.FormData.fromMap({'username': user, 'password': password});
    try {
      Logger.debug('Post login: $user / $password');
      final response = await instance.post('$apiV2Url/users/login', data: data);
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
          traffic: int.parse(resData['traffic']),
        );
        return Response(
          status: true,
          message: 'OK',
          data: {
            'user_info': userInfo,
            'origin_response': resData,
          },
        );
      } else {
        return Response(
          status: false,
          message: resData['msg'] ?? responseJson['status'],
          data: {
            'origin_response': resData,
          },
        );
      }
    } catch (ex, st) {
      Logger.error(ex, t: st);
      return Response(
        status: false,
        message: ex.toString(),
        data: {
          'error': ex,
        },
      );
    }
  }
}
