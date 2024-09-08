// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/utils/logger.dart';

/// 移动文件夹
Future<void> moveDirectory(
  Directory sourceDir,
  Directory targetDir, {
  bool keepParent = false,
}) async {
  // 确保目标目录存在
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  /// 自动递归创建文件夹
  /// [path] 文件夹路径
  gracefullyCreateDirectory(String path) async {
    final dir = Directory(path);
    if (!(await dir.parent.exists())) {
      gracefullyCreateDirectory(dir.parent.path);
    }
    if (!(await dir.exists())) {
      await dir.create();
    }
  }

  // 列出源目录中的所有文件和子目录
  final sourceDirList = sourceDir.list(recursive: false); // 只列出第一层的内容
  await for (FileSystemEntity entity in sourceDirList) {
    String targetPath =
        '${targetDir.path}/${Uri.decodeFull(entity.uri.pathSegments.last)}';
    String newPath = keepParent
        ? targetPath
        : '${Directory(File(targetPath).path).parent.path}/${targetPath.split('/').last}';

    Logger.debug('Target: ${entity.path}');
    Logger.debug('New file path: $newPath');

    if (entity is File) {
      // 移动文件
      File newFile = File(newPath);
      await gracefullyCreateDirectory(newFile.parent.path);
      if (await newFile.exists()) {
        Logger.debug('New file exists, delete it');
        await newFile.delete();
      }
      await entity.copy(newFile.path);
    } else if (entity is Directory) {
      // 移动目录
      Directory newDir = Directory(newPath);
      // 递归调用 moveDirectory，确保子目录处理完成
      await moveDirectory(entity, newDir);
    }
  }
  await sourceDir.delete(recursive: true);
}
