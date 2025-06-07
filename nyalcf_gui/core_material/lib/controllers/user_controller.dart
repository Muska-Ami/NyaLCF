// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core_extend/storages/prefs/token_info_prefs.dart';
import 'package:nyalcf_core_extend/storages/prefs/user_info_prefs.dart';

// 用户控制器
class UserController extends GetxController {
  /// 用户名
  var username = ''.obs;

  /// 邮箱
  var email = ''.obs;

  /// 头像链接
  var avatar = 'https://cravatar.cn/avatar/'.obs;

  /// 流入流量
  var inbound = 0.obs;

  /// 流出流量
  var outbound = 0.obs;

  /// FRP令牌
  var frpToken = ''.obs;

  /// 总流量
  num traffic = 0;
  var trafficRx = '0'.obs;

  /// 欢迎文字
  var welcomeText = '好'.obs;

  /// 加载控制器
  load() async {
    /// 获取用户信息
    UserInfoModel userInfo = await UserInfoPrefs.getInfo();
    username.value = userInfo.username;
    email.value = userInfo.email;
    avatar.value = userInfo.avatar;
    inbound.value = userInfo.inbound;
    outbound.value = userInfo.outbound;
    traffic = userInfo.traffic;
    trafficRx.value = (traffic / 1024).toString();

    frpToken.value = await TokenInfoPrefs.getFrpToken() ?? '';
    welcomeText.value = _welcomeMessage;
  }

  String get _welcomeMessage {
    int hour = DateTime.now().hour;

    /// 根据小时确定欢迎文字
    switch (hour) {
      case 4:
      case 5:
        return '清晨好';
      case 6:
      case 7:
      case 8:
      case 9:
        return '早上好';
      case 10:
      case 11:
      case 12:
        return '中午好';
      case 13:
      case 14:
      case 15:
        return '下午好';
      case 16:
      case 17:
      case 18:
        return '傍晚好';
      case 19:
      case 20:
      case 21:
      case 22:
      case 23:
        return '晚上好';
      case 0:
      case 1:
      case 2:
      case 3:
        return '凌晨好';
      default:
        return '你好不好嘛';
    }
  }
}
