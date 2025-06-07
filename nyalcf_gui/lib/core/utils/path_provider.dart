// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:path_provider/path_provider.dart';

class PathProvider {
  static final _supportPathAsync = getApplicationSupportDirectory();
  static final _cachePathAsync = getApplicationCacheDirectory();

  /// 获取缓存目录
  static Future<String> get _cachePath async {
    String path = Env.universal.cacheDir ?? (await _cachePathAsync).path;
    return path;
  }

  /// 获取数据存储目录
  static Future<String> get _supportPath async {
    String path = Env.universal.supportDir ?? (await _supportPathAsync).path;
    return path;
  }
}
