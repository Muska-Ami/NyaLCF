/// 响应
/// [status] 是否成功
/// [message] 信息
class Response {
  bool status;
  String message;

  Response({
    required this.status,
    required this.message,
  });
}
