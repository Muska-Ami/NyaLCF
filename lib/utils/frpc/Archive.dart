import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:nyalcf/utils/PathProvider.dart';

class FrpcArchive {
  static final _c_path = PathProvider.cache_path;
  static final _s_path = PathProvider.support_path;

  static Future<bool> unarchive({
    required platform,
    required arch,
    required version,
  }) async {
    File f;

    /// 判定平台确定压缩包名称
    if (Platform.isWindows)
      f = File('${await _c_path}/frpc.zip');
    else
      f = File('${await _c_path}/frpc.tar.gz');

    /// 确认 Frpc 是否存在
    if (await f.exists()) {
      extractFileToDisk(f.path, await _c_path);
      final dir = Directory(
          '${await _c_path}/frp_LoCyanFrp-${version}_${platform}_${arch}');
      PathProvider.moveDirectory(dir, Directory('${await _s_path}/frpc/${version}'));
      return true;
    } else {
      return false;
    }
  }
}
