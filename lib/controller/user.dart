import 'package:get/get.dart';
import 'package:nyalcf/model/User.dart';
import 'package:nyalcf/prefs/UserInfoPrefs.dart';

class UserController extends GetxController {
  var user = ''.obs;
  var email = ''.obs;
  var token = ''.obs;
  var avatar = 'https://cravatar.cn/avatar/'.obs;
  var inbound = 0.obs;
  var outbound = 0.obs;
  var frp_token = ''.obs;
  var traffic = 0.obs;

  var welcomeText = '好'.obs;

  load() async {
    User userinfo = await UserInfoPrefs.getInfo();
    user.value = userinfo.user;
    email.value = userinfo.email;
    token.value = userinfo.token;
    avatar.value = userinfo.avatar;
    inbound.value = userinfo.inbound;
    outbound.value = userinfo.outbound;
    frp_token.value = userinfo.frp_token;
    traffic.value = userinfo.traffic;

    int hour = DateTime.now().hour;

    if (hour <= 12) {
      welcomeText.value = '上午好';
    } else {
      welcomeText.value = '下午好';
    }
  }
}
