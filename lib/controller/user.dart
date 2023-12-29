import 'package:get/get.dart';
import 'package:nyalcf/model/User.dart';
import 'package:nyalcf/prefs/UserInfoPrefs.dart';

// 用户控制器
class UserController extends GetxController {
  var user = ''.obs; /// 用户名
  var email = ''.obs; /// 邮箱
  var token = ''.obs; /// 令牌
  var avatar = 'https://cravatar.cn/avatar/'.obs; /// 头像链接，爱来自cravatar（？）
  var inbound = 0.obs; /// 流入流量
  var outbound = 0.obs; /// 流出流量
  var frp_token = ''.obs; /// FRP令牌
  var traffic = 0.obs; /// 总流量

  var welcomeText = '好'.obs; /// 欢迎文字

  /// 加载方法
  load() async {
    /// 获取用户信息
    User userinfo = await UserInfoPrefs.getInfo();
    user.value = userinfo.user;
    email.value = userinfo.email;
    token.value = userinfo.token;
    avatar.value = userinfo.avatar;
    inbound.value = userinfo.inbound;
    outbound.value = userinfo.outbound;
    frp_token.value = userinfo.frp_token;
    traffic.value = userinfo.traffic;

    int hour = DateTime
        .now()
        .hour;

    /// 根据小时确定欢迎文字
    if (hour <= 8) {
      welcomeText.value = '凌晨好';
    } else if (hour <= 12) {
      welcomeText.value = '上午好';
    } else {
      welcomeText.value = '下午好';
    }
  }
