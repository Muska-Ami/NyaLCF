import 'package:dio/dio.dart' as dio;
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/response_type.dart';
import 'package:nyalcf_core/utils/network/dio/basic_config.dart';

class OtherAutoSign {
  final instance = dio.Dio(options);

  /// 检查签到状态
  Future<Response> checkSign(String token) async {
    // Logger.debug(token);
    try {
      dio.FormData data = dio.FormData.fromMap({
        'token': token,
      });
      final resData = await instance.post(
        'https://api.locyanfrp.cn/User/CheckSign',
        data: data,
      );

      Logger.debug(resData);

      Map<String, dynamic> resJson = resData.data;
      final String msg = resJson['message'];

      if (msg.contains("尚未签到")) {
        return Response(
          status: true,
          message: 'OK',
          data: {
            'signed': false,
            'origin_response': resData,
          },
        );
        // final postSign =
        //     await instance.post('https://api.locyanfrp.cn/User/DoSign');
        // final postSignJson = jsonDecode(postSign.data);
        //
        // if (postSignJson['message'] == "成功") {
        //   //提示签到成功
        // } else if (postSignJson['message'] == "已经签到") {
        //   //提示已经签到过了
        // } else {
        // }
      } else if (msg.contains("已签到")) {
        return Response(
          status: true,
          message: 'OK',
          data: {
            'signed': true,
            'origin_response': resData,
          },
        );
      }
      return Response(
        status: false,
        message: msg,
        data: {
          'origin_response': resData,
        },
      );

    } catch (e) {
      Logger.error(e);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }

  /// 执行签到
  Future<Response> doSign(String token) async {
    try {
      dio.FormData data = dio.FormData.fromMap({
        'token': token,
      });
      final resData = await instance.post(
        'https://api.locyanfrp.cn/User/DoSign',
        data: data,
      );
      Map<String, dynamic> resJson = resData.data;
      final String msg = resJson['message'];
      if (msg.contains('签到成功')) {
        int getTraffic = int.parse(msg.replaceAll(RegExp(r'[^0-9]'),'')) * 1024;
        return Response(
          status: true,
          message: 'OK',
          data: {
            'get_traffic': getTraffic,
            'origin_response': resData,
          },
        );
      } else if (msg.contains('已经签到过')) {
        return Response(
          status: false,
          message: 'Signed',
          data: {
            'origin_response': resData,
          },
        );
      }
      return Response(
        status: false,
        message: msg,
        data: {
          'origin_response': resData,
        },
      );
    } catch (e) {
      Logger.error(e);
      return Response(
        status: false,
        message: e.toString(),
        data: {
          'error': e,
        },
      );
    }
  }
}
