import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/models/UserInfoModel.dart';
import 'package:nyalcf/utils/PathProvider.dart';

@deprecated
class UserInfoStorage {
  static final _path = PathProvider.support_path;

  /// 保存数据
  static Future<void> save(UserInfoModel data) async {
    final String write_data = jsonEncode(data);
    await File('${await _path}/session.json')
        .writeAsString(write_data, encoding: utf8);
  }

  /// 读取数据
  static Future<UserInfoModel?> read() async {
    try {
      final String result = await File('${await _path}/session.json')
          .readAsString(encoding: utf8);
      return UserInfoModel.fromJson(jsonDecode(result));
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
