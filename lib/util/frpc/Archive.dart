import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcArchive {
  static final _c_path = FileIO.cache_path;
  static final _s_path = FileIO.support_path;

  static bool unarchive({
    required platform,
    required arch,
    required version,
  }) {
    File f;
    _c_path.then((c_path) {
      if (Platform.isWindows)
        f = File('${c_path}/frpc.zip');
      else
        f = File('${c_path}/frpc.tar.gz');
      if (f.existsSync()) {
        extractFileToDisk(f.path, c_path);
        _s_path.then((s_path) {
          final dir = Directory(
              '${c_path}/frp_LoCyanFrp-${version}_${platform}_${arch}');
          FileIO.moveDirectory(dir, Directory('${s_path}/frpc/${version}'));
          return true;
        });
      } else {
        return false;
      }
    });
    return false;
  }
}
