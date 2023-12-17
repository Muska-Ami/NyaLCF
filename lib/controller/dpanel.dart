import 'package:get/get.dart';
import 'package:nyalcf/dio/other/announcement.dart';

class DPanelController extends GetxController {
  var announcement = "喵喵喵？正在请求捏".obs;

  load() async {
    announcement.value = await AnnouncementDio().get();
  }
}
