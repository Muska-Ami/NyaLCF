import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileIO {
  final _support_path = getApplicationSupportDirectory();
  final _cache_path = getApplicationCacheDirectory();

  Future<void> saveDataToFile(String fi, String data) async {
    final File file = new File("${await _support_path}/$fi");
    await file.writeAsString(data);
  }

  Future<String> readDataFromFile(String fi) async {
    final File file = new File("${await _support_path}/$fi");
    return await file.readAsString(encoding: utf8);
  }

  Future<void> saveCache(String fi, String data) async {
    final File file = new File("${await _cache_path}/$fi");
    await file.writeAsString(data);
  }

  Future<String> readCache(String fi, String data) async {
    final File file = new File("${_cache_path}/$fi");
    return await file.readAsString(encoding: utf8);
  }

  Future<Directory> get cache_path {
    return _cache_path;
  }
}
