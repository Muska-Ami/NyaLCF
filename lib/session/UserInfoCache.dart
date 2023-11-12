import 'package:nyalcf/model/UserInfo.dart';

class UserInfoCache {
  static UserInfo? _userinfo = null;

  static void set info(userinfo) {
    _userinfo = userinfo;
  }

  static UserInfo? get info {
    return _userinfo;
  }

  static void reset() {
    _userinfo = null;
  }
}
