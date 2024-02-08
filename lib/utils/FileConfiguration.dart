import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/utils/Logger.dart';

class FileConfiguration {
  FileConfiguration({
    this.file = null,
  });

  File? file; // Dart Dart 草你吗，定义File?传Future不报错

  static Map<String, dynamic> tmp_data = Map();

  /// 一堆B方法
  /// 气死我里
  /// String
  void setString(String node, String value) => set(node, value);
  String getString(String node) => get(node);
  void setStringList(String node, List<String> value) => setList(node, value);
  List<String> getStringList(String node) => getList(node) as List<String>;

  /// int
  void setInt(String node, int value) => set(node, value);
  int getInt(String node) => get(node);

  /// double
  void setDouble(String node, double value) => set(node, value);
  double getDouble(String node) => get(node);

  /// bool
  void setBool(String node, bool value) => set(node, value);
  bool getBool(String node) => get(node);

  /// Symbol
  void setSymbol(String node, Symbol value) => set(node, value);
  Symbol getSymbol(String node) => get(node);

  /// List
  void setList(String node, List value) => set(node, value);
  List getList(String node) => get(node);

  /// 设置值
  void set(String node, dynamic value) {
    List<String> nl = _parseNode(node);
    dynamic last;
    String n;
    dynamic nx = tmp_data;
    for (n in nl) {
      if (last != null) {
        last = last[n];
        Logger.debug('目标tmp_data状态值: ${tmp_data}');
        Logger.debug('写入迭代NODE: $n');
        Logger.debug('写入迭代LAST: $last');
        Logger.debug('目标tmp_data对象值: ${tmp_data[n] ?? tmp_data[nx]}}');
      } else {
        last = tmp_data[n];
        Logger.debug('目标tmp_data状态值: ${tmp_data}');
        Logger.debug('写入迭代NODE: $n');
        Logger.debug('写入迭代LAST: $last');
        Logger.debug('目标tmp_data对象值: ${tmp_data[n]}');
      }
      nx = n;
    }
    tmp_data[nx] = value;
  }

  /// 获取值
  dynamic get(String node) {
    List<String> nl = _parseNode(node);
    dynamic last;
    String n;
    dynamic nx = tmp_data;
    for (n in nl) {
      if (last != null) {
        last = last[n];
        Logger.debug('目标tmp_data状态值: ${tmp_data}');
        Logger.debug('读取迭代NODE: $n');
        Logger.debug('读取迭代LAST: $last');
        Logger.debug('目标tmp_data对象值: ${tmp_data[n] ?? tmp_data[nx]}');
      } else {
        last = tmp_data[n];
        Logger.debug('目标tmp_data状态值: ${tmp_data}');
        Logger.debug('读取迭代NODE: $n');
        Logger.debug('读取迭代LAST: $last');
        Logger.debug('目标tmp_data对象值: ${tmp_data[n]}');
      }
      nx = n;
    }
    Logger.debug('最终值(${nx}): ${last}');
    return last;
  }

  /// 保存
  Future<void> save({
    File? file = null,
    bool replace = false,
  }) async {
    File? fi = file ?? this.file;
    Logger.debug('目标文件对象: $fi');
    if (fi != null) {
      if (!replace) {
        if (!(await fi.exists())) {
          if (!(await fi.exists())) await fi.create();
          await fi.writeAsString(toString());
        } else {
          Logger.warn('File exist and replace is false, ignoring save action.');
        }
      } else {
        if (!(await fi.exists())) await fi.create();
        await fi.writeAsString(toString());
      }
    } else
      throw UnimplementedError(
          'No specified file selected.Please set a file to use save(); method!');
  }

  /// 设置映射实体文件
  void setFile(File _file) {
    file = _file;
  }

  /// 设置映射实体文件（通过路径）
  void setFilePath(String _path) {
    file = File(_path);
  }

  List<String> _parseNode(String value) => value.split('.');

  /// 转为 String
  @override
  String toString() => json.encode(tmp_data);

  /// 转为 Map String
  String toMapString() => tmp_data.toString();

  /// 从 String 导入
  fromString(String j) => tmp_data = json.decode(j);

  /// 从 Map 导入
  fromMap(Map<String, dynamic> map) => tmp_data = map;
}
