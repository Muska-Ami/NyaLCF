import 'dart:io';

import 'package:nyalcf_core/utils/logger.dart';

/// 移动文件夹
Future<void> moveDirectory(Directory sourceDir, Directory targetDir) async {
  // 确保目标目录存在
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  // 列出源目录中的所有文件和子目录
  final sourceDirList = sourceDir.list(recursive: false); // 只列出第一层的内容
  await for (FileSystemEntity entity in sourceDirList) {
    String newPath = '${targetDir.path}/${Uri.decodeFull(entity.uri.pathSegments.last)}';

    Logger.debug(newPath); // 使用 Logger 输出调试信息
    if (entity is File) {
      // 移动文件
      File newFile = File(newPath);
      await entity.rename(newFile.path);
    } else if (entity is Directory) {
      // 移动目录
      Directory newDir = Directory(newPath);
      // 递归调用 moveDirectory，确保子目录处理完成
      await moveDirectory(entity, newDir);
      // 删除源目录
      await entity.delete(recursive: true);
    }
  }
}
