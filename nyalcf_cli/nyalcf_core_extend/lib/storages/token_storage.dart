import 'dart:io';

import 'package:nyalcf_core/storages/json_configuration.dart';

class TokenStorage extends JsonConfiguration {
  @override
  File get file => File('$path/frpc/proxies/autostart.json');

  @override
  String get handle => 'TOKEN';

  @override
  Map<String, dynamic> get defConfig => {
    'refresh_token': null,
    'access_token': null,
    'frp_token': null,
  };

}
