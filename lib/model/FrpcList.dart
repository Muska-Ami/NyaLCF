class FrpcList {
  FrpcList({
    required this.name,
    required this.description,
    required this.assets,
  });

  final String name;
  final String description;
  final List<Map<String, dynamic>> assets;
}
