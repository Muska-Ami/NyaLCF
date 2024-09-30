// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/response/response.dart';
import 'package:nyalcf_core/network/dio/other/other.dart';

class HomePanelController extends GetxController {
  /// 是否已加载完毕
  static var loaded = false;

  /// <Rx>公告内容
  var broadcast = '喵喵喵？正在请求捏'.obs;

  /// <Rx>通知内容
  var announcement = '喵喵喵？正在请求捏'.obs;

  /// 加载控制器
  load() async {
    final notice = await OtherAnnouncement.getNotice();
    if (notice.status) {
      notice as NoticeResponse;
      broadcast.value = notice.broadcast;
      announcement.value = notice.announcement;
    } else if (!loaded) {
      broadcast.value = '获取失败了啊呜，可能是猫猫把网线偷走了~';
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
    loaded = true;
  }
}
