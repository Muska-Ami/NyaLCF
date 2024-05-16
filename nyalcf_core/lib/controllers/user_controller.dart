import 'package:get/get.dart';
import 'package:nyalcf_core/models/user_info_model.dart';
import 'package:nyalcf_core/storages/prefs/user_info_prefs.dart';

// 用户控制器
class UserController extends GetxController {
  /// 用户名
  var user = ''.obs;

  /// 邮箱
  var email = ''.obs;

  /// 令牌
  var token = ''.obs;

  /// 头像链接
  var avatar = 'https://cravatar.cn/avatar/'.obs;

  /// 流入流量
  var inbound = 0.obs;

  /// 流出流量
  var outbound = 0.obs;

  /// FRP令牌
  var frpToken = ''.obs;

  /// 总流量
  var traffic = 0.obs;

  /// 欢迎文字
  var welcomeText = '好'.obs;

  /// 加载方法
  load() async {
    /// 获取用户信息
    UserInfoModel userinfo = await UserInfoPrefs.getInfo();
    user.value = userinfo.user;
    email.value = userinfo.email;
    token.value = userinfo.token;
    avatar.value = userinfo.avatar;
    inbound.value = userinfo.inbound;
    outbound.value = userinfo.outbound;
    frpToken.value = userinfo.frpToken;
    traffic.value = userinfo.traffic;

    int hour = DateTime.now().hour;

    /// 根据小时确定欢迎文字
    if (hour <= 8) {
      welcomeText.value = '凌晨好';
    } else if (hour <= 12) {
      welcomeText.value = '上午好';
    } else {
      welcomeText.value = '下午好';
    }
  }
}
