// Dart imports:
import 'dart:io';

// Project imports:
import 'package:core/storages/json_configuration.dart';

class FrpcConfigurationStorage extends JsonConfiguration {
  @override
  File get file => File('$path/frpc.json');

  @override
  String get handle => 'FRPC';

  @override
  Map<String, dynamic> get defConfig => {
        'settings': {
          'frpc_version': null,
        },
        'lists': {
          'frpc_installed_versions': <String>[],
        },
      };

  /// 获取使用的 Frpc 版本
  String getSettingsFrpcVersion() => cfg.getString(
      'settings.frpc_version', defConfig['settings']['frpc_version']);

  /// 设置使用的 Frpc 版本
  /// [value] Frpc 版本
  void setSettingsFrpcVersion(String value) =>
      cfg.setString('settings.frpc_version', value);

  /// 获取已安装的 Frpc 版本
  List<String> getInstalledVersions() =>
      cfg.getStringList('lists.frpc_installed_versions');

  /// 添加已安装的 Frpc 版本
  /// [value] 版本号
  void addInstalledVersion(String value) {
    final List<String> list = getInstalledVersions();
    list.add(value);
    cfg.setStringList('lists.frpc_installed_versions', list.toSet().toList());
  }

  /// 移除已安装的 Frpc 版本
  /// [value] 版本号
  void removeInstalledVersion(String value) {
    final List<String> list = getInstalledVersions();
    list.remove(value);
    cfg.setStringList('lists.frpc_installed_versions', list.toSet().toList());
  }

}
