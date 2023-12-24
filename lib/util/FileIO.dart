import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileIO {
  static final _support_path = getApplicationSupportDirectory();
  static final _cache_path = getApplicationCacheDirectory();

  /**
   * 获取缓存目录
   */
  static Future<String> get cache_path async {
    String path = '';
    await _cache_path.then((value) => path = value.path);
    print('Get cache path $path');
    return path;
  }

  /**
   * 获取数据存储目录
   */
  static Future<String> get support_path async {
    String path = '';
    await _support_path.then((value) => path = value.path);
    print('Get support path: $path');
    return path;
  }

  /**
   * 移动文件夹
   */
  static void moveDirectory(Directory sourceDir, Directory targetDir) {
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
    }

    sourceDir.listSync().forEach((FileSystemEntity entity) {
      String newPath = targetDir.path + '/' + entity.uri.pathSegments.last;

      if (entity is File) {
        File newFile = File(newPath);
        entity.renameSync(newFile.path);
      } else if (entity is Directory) {
        Directory newDir = Directory(newPath);
        moveDirectory(entity, newDir);
        entity.deleteSync();
      }
    });
  }
}
