// Project imports:
import 'package:nyalcf_core_extend/storages/token_storage.dart';

class CliStoragesInjector {
  /// 初始化数据存储
  static init() async {
    final ts = TokenStorage();

    await ts.initCfg();
  }
}
