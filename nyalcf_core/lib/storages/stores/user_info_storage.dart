// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:nyalcf_inject/nyalcf_inject.dart';

// Project imports:
import 'package:nyalcf_core/models/user_info_model.dart';

class UserInfoStorage {
  static final _path = appSupportPath;

  /// 保存用户数据
  /// [data] 用户信息
  static Future<void> save(UserInfoModel data) async {
    final String writeData = jsonEncode(data);
    await File('$_path/session.json').writeAsString(writeData, encoding: utf8);
  }

  /// 读取用户数据
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
  /// [username] 用户名
  /// [token] 登录令牌
  /// [deleteSessionFileOnly] 是否只删除 session.json
  static Future<void> logout() async {
    await File('$_path/session.json').delete();
  }
}
