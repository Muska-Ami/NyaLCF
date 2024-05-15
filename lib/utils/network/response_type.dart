class Response {
  bool status;
  String message;
  Map<String, dynamic> data;

  Response({
    required this.status,
    required this.message,
    required this.data,
  });
}