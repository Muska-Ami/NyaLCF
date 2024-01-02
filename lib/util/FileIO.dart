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
  static void moveDirectory(Directory sourceDir, Directory targetDir) async {
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final sourceDirList = await sourceDir.list();
    await sourceDirList.forEach((FileSystemEntity entity) async {
      String newPath =
          targetDir.path + '/' + Uri.decodeFull(entity.uri.pathSegments.last);

      print(newPath);
      if (entity is File) {
        File newFile = File(newPath);
        await entity.rename(newFile.path);
      } else if (entity is Directory) {
        Directory newDir = Directory(newPath);
        moveDirectory(entity, newDir);
        await entity.delete();
      }
    });
  }
}
