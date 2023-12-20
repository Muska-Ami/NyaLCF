import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcController extends GetxController {
  final _support_path = FileIO.support_path;
  var exist = false.obs;
  var version = ''.obs;

  load() async {
    exist.value = await file.exists();
  }

  /// 获取Frpc文件对象
  get file => FrpcManagerStorage.getFile(version.value);

  Future<String> getVersion() async {
    String path = await _support_path + '/setting/frpc.json';
    final setting = File(path).readAsString();
    final Map<String, dynamic> settingJson = jsonDecode(await setting);
    return settingJson['use_version'];
  }
}
