// Dart imports:
import 'dart:convert';
import 'dart:io';

//import 'package:nyalcf/utils/Logger.dart';

class FileConfiguration {
  FileConfiguration({
    this.file,
    required this.handle,
  });

  /// 配置文件对象
  File? file; // Dart Dart 草你吗，定义File?传Future不报错
  /// 配置唯一 handle 用于区分配置
  final String handle;

  /// 临时数据，会存储在内存种
  static Map<String, dynamic> tmpData = {};

  /// 初始化内存对象
  void initMap() {
    tmpData[handle] = {};
  }

  // 一堆B方法
  // 气死我里
  /// String
  void setString(String node, String value) => set(node, value);

  String getString(String node, String? defaultValue) => get(node, defaultValue);

  void setStringList(String node, List<String> value) => setList(node, value);

  List<String> getStringList(String node) =>
      getList(node, []).map((item) => item as String).toList();

  /// int
  void setInt(String node, int value) => set(node, value);

  int getInt(String node, int? defaultValue) => get(node, defaultValue);

  /// double
  void setDouble(String node, double value) => set(node, value);

  double getDouble(String node, double? defaultValue) => get(node, defaultValue);

  /// bool
  void setBool(String node, bool value) => set(node, value);

  bool getBool(String node, bool? defaultValue) => get(node, defaultValue);

  /// Symbol
  void setSymbol(String node, Symbol value) => set(node, value);

  Symbol getSymbol(String node, Symbol? defaultValue) => get(node, defaultValue);

  /// List
  void setList(String node, List value) => set(node, value);

  List getList(String node, List? defaultValue) => get(node, defaultValue);

  /// 设置值
  void set(String node, dynamic value) {
    List<String> nl = _parseNode(node);
    dynamic last = tmpData[handle]; // 初始化last为tmp_data的引用
    String? n;
    for (int i = 0; i < nl.length; i++) {
      n = nl[i];
      if (i == nl.length - 1) {
        last[n] = value;
      } else {
        if (last[n] == null || last[n] is! Map) {
          last[n] = {};
        }
        last = last[n];
      }
    }
  }

  /// 获取值
  dynamic get(String node, dynamic defaultValue) {
    List<String> nl = _parseNode(node);
    dynamic last;
    String? n;
    for (n in nl) {
      if (last != null) {
        last = last[n];
        //Logger.debug('目标tmp_data状态值: ${tmp_data[handle]}');
        //Logger.debug('读取迭代NODE: $n');
        //Logger.debug('读取迭代LAST: $last');
      } else {
        last = tmpData[handle][n];
        //Logger.debug('目标tmp_data状态值: ${tmp_data[handle]}');
        //Logger.debug('读取迭代NODE: $n');
        //Logger.debug('读取迭代LAST: $last');
      }
    }

    if (last == null && defaultValue != null) {
      set(node, defaultValue);
      return defaultValue;
    }
    //Logger.debug('最终值(${n}): ${last}');
    return last;
  }

  /// 保存
  Future<void> save({
    File? file,
    bool replace = false,
  }) async {
    File? fi = file ?? this.file;
    if (fi != null) {
      if (!replace) {
        if (!(await fi.exists())) {
          await fi.create(recursive: true);
          await fi.writeAsString(toString());
        }
      } else {
        if (!(await fi.exists())) await fi.create(recursive: true);
        await fi.writeAsString(toString());
      }
    } else {
      throw UnimplementedError(
          'No specified file selected. Please set a file to use save() method!');
    }
  }

  /// 设置映射实体文件
  void setFile(File file) {
    this.file = file;
  }

  /// 设置映射实体文件（通过路径）
  void setFilePath(String path) {
    file = File(path);
  }

  List<String> _parseNode(String value) => value.split('.');

  /// 转为 String
  @override
  String toString() => json.encode(tmpData[handle]);

  /// 转为 Map String
  String toMapString() => tmpData[handle].toString();

  /// 从 String 导入
  fromString(String j) => tmpData[handle] = json.decode(j);

  /// 从 Map 导入
  fromMap(Map<String, dynamic> map) => tmpData[handle] = map;

  Future<void> reload() async {
    if (file != null) {
      fromString(await file!.readAsString());
    } else {
      throw UnimplementedError(
          'Could not load configuration from undefined file!');
    }
  }
}
