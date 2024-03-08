import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:nyalcf/utils/path_provider.dart';

class FrpcArchive {
  static final _cachePath = PathProvider.appCachePath;
  static final _supportPath = PathProvider.appSupportPath;

  static Future<bool> unarchive({
    required platform,
    required arch,
    required version,
  }) async {
    File f;

    /// 判定平台确定压缩包名称
    if (Platform.isWindows) {
      f = File('$_cachePath/frpc.zip');
    } else {
      f = File('$_cachePath/frpc.tar.gz');
    }

    /// 确认 Frpc 是否存在
    if (await f.exists()) {
      extractFileToDisk(f.path, _cachePath!);
      final dir = Directory(
          '$_cachePath/frp_LoCyanFrp-${version.toString().split('-')[0]}_${platform}_$arch');
      PathProvider.moveDirectory(dir, Directory('$_supportPath/frpc/$version'));
      return true;
    } else {
      return false;
    }
  }
}
