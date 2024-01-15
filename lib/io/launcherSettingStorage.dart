import 'dart:convert';
import 'dart:io';

import 'package:nyalcf/model/LauncherSetting.dart';
import 'package:nyalcf/util/FileIO.dart';

class LauncherSettingStorage {
  static final _path = FileIO.support_path;

  static void init() {
    _path.then((path) {
      if (!Directory(path).existsSync()) Directory(path).createSync();
      final infoF = File('${path}/settings.json');
      if (!infoF.existsSync()) {
        Map<String, dynamic> json = {
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
        infoF.writeAsStringSync(jsonEncode(json));
      }
    });
  }

  /// 保存数据
  static Future<void> save(LauncherSetting data) async {
    final String write_data = jsonEncode(data);
    await File('${await _path}/settings.json')
        .writeAsString(write_data, encoding: utf8);
  }

  /// 读取数据
  static Future<LauncherSetting?> read() async {
    try {
      final String result =
          File('${await _path}/settings.json').readAsStringSync(encoding: utf8);
      return LauncherSetting.fromJson(jsonDecode(result));
    } catch (e) {
      return null;
    }
  }
}
