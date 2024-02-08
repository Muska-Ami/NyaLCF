import 'dart:io';

import 'package:nyalcf/storages/Configuration.dart';
import 'package:nyalcf/utils/FileConfiguration.dart';

class LauncherConfigurationStorage extends Configuration {

  @override
  Future<FileConfiguration> get config async => FileConfiguration(file: File('${await path}/launcher.json'));

  @override
  Future<Map<String, dynamic>> get def_config async => {
    'theme': {
      'auto': true,
      'dark': {
        'enable': false,
      },
      'light': {
        'seed': {
          'enable': false,
          'value': '66ccff',
        },
      }
    },
  };

}