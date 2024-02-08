import 'dart:io';

import 'package:nyalcf/utils/FileConfiguration.dart';
import 'package:nyalcf/utils/PathProvider.dart';
import 'package:nyalcf/utils/Logger.dart';

abstract class Configuration {
  var path = PathProvider.appSupportPath;

  /// 配置文件和默认ConfigMap
  File? file;
  Future<Map<String, dynamic>> get def_config async => {};

  /// 附加Init方法
  void init() => {};
  Future<void> asyncInit() async => {};

  FileConfiguration get cfg => FileConfiguration(file: this.file);

  /// 保存
  void save() => cfg.save(replace: true);

  /// 默认初始化函数
  void initCfg() async {
    cfg.fromMap(await def_config);
    Logger.debug(file);
    cfg.save();
    init();
    asyncInit();
  }
}
