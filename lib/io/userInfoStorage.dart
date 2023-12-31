import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/model/User.dart';
import 'package:nyalcf/util/FileIO.dart';

class UserInfoStorage {
  static final _path = FileIO.support_path;

  /// 保存数据
  static Future<void> save(User data) async {
    final String write_data = jsonEncode(data);
    await File('${await _path}/session.json')
        .writeAsString(write_data, encoding: utf8);
  }

  /// 读取数据
  static Future<User?> read() async {
    try {
      final String result = await File('${await _path}/session.json')
          .readAsString(encoding: utf8);
      return User.fromJson(jsonDecode(result));
    } catch (e) {
      return null;
    }
  }

  /// 退出登录
  /// 只是删除session.json
  static sigo() async {
    await File('${await _path}/session.json').delete();
  }
}
