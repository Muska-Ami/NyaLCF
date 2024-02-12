import 'dart:io';

import 'package:nyalcf/utils/Logger.dart';
import 'package:path_provider/path_provider.dart';

class PathProvider {
  static final _supportPathAsync = getApplicationSupportDirectory();
  static final _cachePathAsync = getApplicationCacheDirectory();

  /// 假的同步，实际上就是刚启动缓存成变量了
  static String? appCachePath;
  static String? appSupportPath;

  /// 获取缓存目录
  static Future<String> get _cachePath async {
    String path = (await _cachePathAsync).path;
    return path;
  }

  /// 获取数据存储目录
  static Future<String> get _supportPath async {
    String path = (await _supportPathAsync).path;
    return path;
  }

  static Future<void> loadSyncPath() async {
    appCachePath = await _cachePath;
    appSupportPath = await _supportPath;
  }

  /// 移动文件夹
  static void moveDirectory(Directory sourceDir, Directory targetDir) async {
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final sourceDirList = sourceDir.list();
    await sourceDirList.forEach((FileSystemEntity entity) async {
      String newPath =
          '${targetDir.path}/${Uri.decodeFull(entity.uri.pathSegments.last)}';

      Logger.debug(newPath);
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
