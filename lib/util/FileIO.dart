import 'package:path_provider/path_provider.dart';

class FileIO {
  final _support_path = getApplicationSupportDirectory();
  final _cache_path = getApplicationCacheDirectory();

  Future<String> get cache_path async {
    String path = "";
    await _cache_path.then((value) => path = value.path);
    return path;
  }
}
