import 'dart:convert';
import 'dart:io';

import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/utils/path_provider.dart';

class UserInfoStorage {
  static final _path = PathProvider.appSupportPath;

  /// 保存数据
  static Future<void> save(UserInfoModel data) async {
    final String writeData = jsonEncode(data);
    await File('$_path/session.json').writeAsString(writeData, encoding: utf8);
  }

  /// 读取数据
  static Future<UserInfoModel?> read() async {
    try {
      final String result =
          await File('$_path/session.json').readAsString(encoding: utf8);
      return UserInfoModel.fromJson(jsonDecode(result));
    } catch (e) {
      return null;
    }
  }

  /// 退出登录
  /// 只是删除session.json
  static sigo() async {
    await File('$_path/session.json').delete();
  }
}
