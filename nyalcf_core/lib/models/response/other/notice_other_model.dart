// Project imports:
import 'package:nyalcf_core/models/response/response.dart';

/// 公告响应
/// [broadcast] 公告内容, 使用 Markdown 语法
/// [announcement] 通知内容, 使用 Markdown 语法
class NoticeResponse extends Response {
  NoticeResponse({
    required this.broadcast,
    required this.announcement,
    super.status = true,
    required super.message,
  });

  final String broadcast;
  final String announcement;
}
