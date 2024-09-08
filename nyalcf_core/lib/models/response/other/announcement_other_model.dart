// Project imports:
import 'package:nyalcf_core/models/response/response.dart';

/// 公告响应
/// [broadcast] 公告内容, 使用 Markdown 语法
class BroadcastResponse extends Response {
  BroadcastResponse({
    required this.broadcast,
    super.status = true,
    required super.message,
  });

  final String broadcast;
}

/// 通知响应
/// [ads] 通知内容, 使用 Markdown 语法
class AdsResponse extends Response {
  AdsResponse({
    required this.ads,
    super.status = true,
    required super.message,
  });

  final String ads;
}
