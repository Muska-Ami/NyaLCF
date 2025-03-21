// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:path_provider/path_provider.dart';

class PathProvider {
  static final _supportPathAsync = getApplicationSupportDirectory();
  static final _cachePathAsync = getApplicationCacheDirectory();

  /// 获取缓存目录
  static Future<String> get _cachePath async {
    String path = ENV_UNIVERSAL_CACHE_DIR ?? (await _cachePathAsync).path;
    return path;
  }

  /// 获取数据存储目录
  static Future<String> get _supportPath async {
    String path = ENV_UNIVERSAL_SUPPORT_DIR ?? (await _supportPathAsync).path;
    return path;
  }

  /// 初始化路径信息
  static Future<void> loadSyncPath() async {
    setAppCachePath(await _cachePath);
    setAppSupportPath(await _supportPath);
  }
}
