import 'dart:io';

import 'package:nyalcf_core/utils/logger.dart';

/// 移动文件夹
void moveDirectory(Directory sourceDir, Directory targetDir) async {
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
