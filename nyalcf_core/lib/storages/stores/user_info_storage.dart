import 'dart:convert';
import 'dart:io';

import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/network/dio/auth/auth.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';

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
  /// [user] 用户名
  /// [token] 登录令牌
  /// [deleteSessionFileOnly] 是否只删除 session.json
  static Future<bool> sigo(user, token, {deleteSessionFileOnly = false}) async {
    deleteFile() async {
      await File('$_path/session.json').delete();
      return true;
    }

    if (!deleteSessionFileOnly) {
      final res = await LogoutAuth.requestLogout(user, token);
      if (res.status) {
        await deleteFile();
        return true;
      }
    } else {
      await deleteFile();
      return true;
    }
    return false;
  }
}
