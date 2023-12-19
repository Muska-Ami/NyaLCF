import 'dart:io';

import 'package:get/get.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcController extends GetxController {
  final _support_path = FileIO.support_path;
  var exist = false.obs;
  var version = ''.obs;

  load() async {
    exist.value = await file().exists();
  }

  /// 获取Frpc文件对象
  File file() {
    String path = '';
    _support_path.then((value) {
      path = value + '/frpc/${version}/frpc';
    });
    if (Platform.isWindows) path += '.exe';
    return File(path);
  }

  Future<String> getVersion() async {
    String path = await _support_path + '/frpc/frpc_info.json';
    return await File(path).readAsString();
  }
}
