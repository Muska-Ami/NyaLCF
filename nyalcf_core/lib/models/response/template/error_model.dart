import 'package:nyalcf_core/models/response/response.dart';

/// 错误响应
/// [exception] 异常对象
/// [stackTrace] 堆栈追踪信息
class ErrorResponse extends Response {
  ErrorResponse({
    this.exception,
    this.stackTrace,
    super.status = false,
    required super.message,
  });

  final Object? exception;
  final StackTrace? stackTrace;
}
