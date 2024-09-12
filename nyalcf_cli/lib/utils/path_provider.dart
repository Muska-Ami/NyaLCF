// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_env/nyalcf_env.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

class PathProvider {
  static final basicPath =
      '${Directory(Platform.resolvedExecutable).parent.path}/.nyalcf';

  static Future<void> loadPath() async {
    final cachePath = ENV_UNIVERSAL_CACHE_DIR ?? '$basicPath/cache';
    final supportPath = ENV_UNIVERSAL_SUPPORT_DIR ?? '$basicPath/data';

    final dirBase = Directory(basicPath);
    final dirCache = Directory(cachePath);
    final dirSupport = Directory(supportPath);

    if (!(await dirBase.exists())) await dirBase.create();
    if (!(await dirCache.exists())) await dirCache.create();
    if (!(await dirSupport.exists())) await dirSupport.create();

    setAppCachePath(cachePath);
    setAppSupportPath(supportPath);
  }
}
