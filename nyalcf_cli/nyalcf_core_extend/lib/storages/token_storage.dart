// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/storages/json_configuration.dart';

class TokenStorage extends JsonConfiguration {
  @override
  File get file => File('$path/token.json');

  @override
  String get handle => 'TOKEN';

  @override
  Map<String, dynamic> get defConfig => {
        'refresh_token': null,
        'access_token': null,
        'frp_token': null,
      };

  void setRefreshToken(String value) => cfg.setString('refresh_token', value);
  String? getRefreshToken() =>
      cfg.getString('refresh_token', defConfig['refresh_token']);

  void setAccessToken(String value) => cfg.setString('access_token', value);
  String? getAccessToken() =>
      cfg.getString('access_token', defConfig['access_token']);

  void setFrpToken(String value) => cfg.setString('frp_token', value);
  String? getFrpToken() => cfg.getString('frp_token', defConfig['frp_token']);
}
