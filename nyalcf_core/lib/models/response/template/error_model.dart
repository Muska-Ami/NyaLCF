import 'package:nyalcf_core/models/response/response.dart';

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
