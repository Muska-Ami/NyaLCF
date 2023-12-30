import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcArchive {
  static final _c_path = FileIO.cache_path;
  static final _s_path = FileIO.support_path;

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
    /// 确认 Frpc 是否已存在
    if (await f.exists()) {
      extractFileToDisk(f.path, await _c_path);
      final dir = Directory(
          '${await _c_path}/frp_LoCyanFrp-${version}_${platform}_${arch}');
      FileIO.moveDirectory(dir, Directory('${await _s_path}/frpc/${version}'));
      return true;
    } else {
      return false;
    }
  }
}
