// Dart imports:
import 'dart:io';

// Package imports:
import 'package:archive/archive_io.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf_core/utils/logger.dart';

class FrpcArchive {
  static final _cachePath = appCachePath;
  static final _supportPath = appSupportPath;

  /// 解压下载的 Frpc
  /// [platform] 平台
  /// [arch] 架构
  /// [version] Frpc 版本
  static Future<bool> extract({
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
      try {
        Logger.debug('Extract frpc into cache: $_cachePath');
        await extractFileToDisk(f.path, _cachePath!);
        final dir = Directory(
            '$_cachePath/frp_LoCyanFrp-${version.toString().split('-')[0]}_${platform}_$arch');
        Logger.debug('Move frpc into: $_supportPath/frpc/$version');
        await moveDirectory(dir, Directory('$_supportPath/frpc/$version'));
        Logger.debug('Extract frpc package done.');
        await f.delete();
      } catch (e, st) {
        await f.delete();
        Logger.error(e, t: st);
        return false;
      }
      return true;
    } else {
      return false;
    }
  }
}
