import 'package:get/get.dart';

import 'package:nyalcf_core/utils/network/dio/other/other.dart';

class DPanelController extends GetxController {
  static var loaded = false;
  var announcement = '喵喵喵？正在请求捏'.obs;
  var announcementCommon = '喵喵喵？正在请求捏'.obs;

  load() async {
    final broadcast = await OtherAnnouncement().getBroadcast();
    final ads = await OtherAnnouncement().getAds();
    if (broadcast.status) {
      announcement.value = broadcast.data['broadcast'];
    } else if (!loaded) {
      announcement.value = '获取失败了啊呜，可能是猫猫把网线偷走了~';
      Get.snackbar(
        '获取公告失败',
        '可能网线被猫猫偷走惹！',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        '获取公告失败',
        '可能不是最新的公告',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
    if (ads.status) {
      announcementCommon.value = ads.data['ads'];
    } else if (!loaded) {
      announcementCommon.value = '获取失败了啊呜，可能是猫猫把网线偷走了~';
      Get.snackbar(
        '获取通知失败',
        '可能网线被猫猫偷走惹！',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    } else {
      Get.snackbar(
        '获取通知失败',
        '可能不是最新的通知',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
    loaded = true;
  }
}
