// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf_core/utils/file_configuration.dart';

abstract class JsonConfiguration {
  var path = appSupportPath;

  /// 配置文件和默认 ConfigMap
  File? file;

  /// 指定唯一 handle 用于区分配置
  String get handle;

  /// 配置文件默认内容
  Future<Map<String, dynamic>> get defConfig async => {};

  /// 附加 Init 方法
  void init() => {};

  /// 附加异步 Init 方法
  Future<void> asyncInit() async => {};

  /// 配置文件对象
  FileConfiguration get cfg => FileConfiguration(
        file: file,
        handle: sha1.convert(utf8.encode(handle)).toString(),
      );

  /// 保存配置到磁盘
  void save() => cfg.save(replace: true);

  /// 从磁盘重载
  Future<void> reloadFromDisk() async {
    await cfg.reload();
  }

  /// 默认初始化函数
  Future<void> initCfg() async {
    cfg.initMap();
    if (await file?.exists() == true) {
      cfg.fromString(await file!.readAsString());
    } else {
      cfg.fromMap(await defConfig);
      cfg.save();
    }
    init();
    asyncInit();
  }
}
