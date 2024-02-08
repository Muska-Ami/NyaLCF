import 'package:nyalcf/utils/FileConfiguration.dart';
import 'package:nyalcf/utils/PathProvider.dart';

abstract class Configuration {
  var path = PathProvider.support_path;

  /// 配置文件和默认config
  Future<FileConfiguration> get config;
  Future<Map<String, dynamic>> get def_config async => {};

  void init() => {};
  Future<void> asyncInit() async => {};

  void initCfg() async {
    FileConfiguration config = await this.config;
    config.fromMap(await def_config);
    config.save();
    init();
    asyncInit();
  }

}