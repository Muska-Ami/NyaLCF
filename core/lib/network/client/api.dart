abstract class Api {
  Api({
    required this.endpoint,
    required this.method,
    required this.params,
    this.validateStatus = const [200],
  });

  final String endpoint;
  final ApiRequestMethod method;
  final Map<String, dynamic> params;
  List<int> validateStatus;
}

enum ApiRequestMethod {
  get,
  post,
  delete,
  put,
  patch,
}
