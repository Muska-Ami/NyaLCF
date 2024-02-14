import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:nyalcf/utils/file_configuration.dart';
import 'package:nyalcf/utils/path_provider.dart';

abstract class JsonConfiguration {
  var path = PathProvider.appSupportPath;

  /// 配置文件和默认ConfigMap
  File? file;
  String get handle;
  Future<Map<String, dynamic>> get defConfig async => {};

  /// 附加Init方法
  void init() => {};
  Future<void> asyncInit() async => {};

  FileConfiguration get cfg => FileConfiguration(
        file: file,
        handle: sha1.convert(utf8.encode(handle)).toString(),
      );

  /// 保存
  void save() => cfg.save(replace: true);

  /// 默认初始化函数
  void initCfg() async {
    cfg.initMap();
    cfg.fromMap(await defConfig);
    //Logger.debug(file);
    cfg.save();
    init();
    asyncInit();
  }
}
