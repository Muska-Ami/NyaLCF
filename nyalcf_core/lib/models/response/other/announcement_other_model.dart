import 'package:nyalcf_core/models/response/response.dart';

class BroadcastResponse extends Response {
  BroadcastResponse({
    required this.broadcast,
    super.status = true,
    required super.message,
  });

  final String broadcast;
}

class AdsResponse extends Response {
  AdsResponse({
    required this.ads,
    super.status = true,
    required super.message,
  });

  final String ads;
}
