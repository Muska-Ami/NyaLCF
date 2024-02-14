import 'package:get/get.dart';
import 'package:nyalcf/utils/network/dio/other/announcement.dart';

class DPanelController extends GetxController {
  var announcement = '喵喵喵？正在请求捏'.obs;
  var announcementCommon = '喵喵喵？正在请求捏'.obs;

  load() async {
    announcement.value = await AnnouncementDio().getBroadcast();
    announcementCommon.value = await AnnouncementDio().getCommon();
  }
}
