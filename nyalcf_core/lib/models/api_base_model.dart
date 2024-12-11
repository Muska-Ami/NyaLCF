abstract class ApiBaseModel {
  ApiBaseModel({
    required this.endpoint,
    required this.params,
    this.validateStatus = const [200],
  });

  final String endpoint;
  final Map<String, dynamic> params;
  List<int> validateStatus;
}
