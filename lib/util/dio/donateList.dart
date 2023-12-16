import 'dart:math';

import 'package:dio/dio.dart';
import 'basicConfig.dart';

import '../model/DonateInfo.dart';

class DonateList {
  final dio = Dio();

  Future<dynamic> random() async {
    try {
      print("Get donate list");
      final response =
          await dio.get("${basicConfig.api_v1_url}/Donate/GetDonateList");
      List<Map<String, dynamic>> responseJson = response.data;
      print(responseJson);
      final Map<String, dynamic> resData =
          responseJson[Random().nextInt(responseJson.length - 1)];
      final donateInfo = DonateRandom(
          username: resData["username"], message: resData["message"]);
      return donateInfo;
    } catch (ex) {
      print(ex);
      return DonateRandom(username: "N", message: "A");
    }
  }
}
