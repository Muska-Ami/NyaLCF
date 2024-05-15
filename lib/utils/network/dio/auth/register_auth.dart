import 'package:dio/dio.dart' as dio;
import 'package:nyalcf/utils/logger.dart';
import 'package:nyalcf/utils/network/dio/basic_config.dart';
import 'package:nyalcf/utils/network/response_type.dart';

class RegisterAuth {
  final instance = dio.Dio(options);

  Future<Response> requestRegister(
      user, password, confirmPassword, email, verify, qq) async {
    dio.FormData data = dio.FormData.fromMap({
      'username': user,
      'password': password,
      'confirm_password': confirmPassword,
      'email': email,
      'verify': verify,
      'qq': qq,
    });
    try {
      Logger.debug(
          'Post register: $user - $email / $password - $confirmPassword / $verify');
      final response =
          await instance.post('$apiV2Url/users/register', data: data);
      Map<String, dynamic> responseJson = response.data;
      Logger.debug(responseJson);
      final resData = responseJson['data'];
      if (responseJson['status'] == 200) {
        return Response(
          status: true,
          message: 'OK',
          data: {
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
    } catch (ex) {
      Logger.error(ex);
      return Response(
        status: false,
        message: ex.toString(),
        data: {
          'error': ex,
        },
      );
    }
  }

  Future<Response> requestCode(email) async {
    try {
      Logger.debug('Requesting email code, email: $email');
      Map<String, dynamic> paramsMap = {};
      paramsMap['email'] = email;
      final response = await instance.get(
        '$apiV2Url/users/send',
        queryParameters: paramsMap,
      );
      final resData = response.data;
      if (resData['msg'] == 'success') {
        return Response(
          status: true,
          message: 'OK',
          data: {
            'origin_response': resData,
          },
        );
      } else {
        return Response(
          status: false,
          message: resData['msg'],
          data: {
            'origin_response': resData,
          },
        );
      }
    } catch (ex) {
      Logger.error(ex);
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
