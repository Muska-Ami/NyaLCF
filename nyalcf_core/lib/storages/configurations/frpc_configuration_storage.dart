import 'dart:io';

import 'package:nyalcf_core/storages/json_configuration.dart';

class FrpcConfigurationStorage extends JsonConfiguration {
  @override
  File get file => File('$path/frpc.json');

  @override
  String get handle => 'FRPC';

  @override
  Future<Map<String, dynamic>> get defConfig async => {
        'settings': {
          'frpc_version': '0.51.3-3',
          'github_mirror': true,
        },
        'lists': {
          'frpc_installed_versions': <String>[],
        },
      };

  /// 使用的 Frpc 版本
  String getSettingsFrpcVersion() => cfg.getString('settings.frpc_version');

  void setSettingsFrpcVersion(String value) =>
      cfg.setString('settings.frpc_version', value);

  /// 使用镜像源
  bool getSettingsGitHubMirror() => cfg.getBool('settings.github_mirror');

  void setSettingsGitHubMirror(bool value) =>
      cfg.setBool('settings.github_mirror', value);

  /// 已安装的 Frpc 版本
  List<String> getInstalledVersions() =>
      cfg.getStringList('lists.frpc_installed_versions');

  void addInstalledVersion(String value) {
    final List<String> list = getInstalledVersions();
    list.add(value);
    cfg.setStringList('lists.frpc_installed_versions', list.toSet().toList());
  }
}
