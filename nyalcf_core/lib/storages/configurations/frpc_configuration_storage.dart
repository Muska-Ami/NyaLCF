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
          'frpc_version': '0.51.3-4',
          'frpc_download_mirror': true,
          'frpc_download_mirror_id': 'muska-github-mirror',
        },
        'lists': {
          'frpc_installed_versions': <String>[],
          'frpc_download_mirrors': <Map<String, dynamic>>[
            {
              'name': 'Muska Network GitHub Object Mirror',
              'id': 'muska-github-mirror',
              'format':
                  'https://proxy-gh.1l1.icu/github.com/{owner}/{repo}/releases/download/v{version}/frp_LoCyanFrp-{version_pure}_{platform}_{arch}.{suffix}',
            },
            {
              'name': 'LoCyan Mirrors',
              'id': 'locyan-mirror',
              'format':
                  'https://mirrors.locyan.cn/github-release/{owner}/{repo}/{release_name}/frp_LoCyanFrp-{version_pure}_{platform}_{arch}.{suffix}',
            },
          ],
        },
      };

  /// 使用的 Frpc 版本
  String getSettingsFrpcVersion() => cfg.getString('settings.frpc_version');

  void setSettingsFrpcVersion(String value) =>
      cfg.setString('settings.frpc_version', value);

  /// 使用镜像源
  bool getSettingsFrpcDownloadMirror() =>
      cfg.getBool('settings.frpc_download_mirror');

  void setSettingsFrpcDownloadMirror(bool value) =>
      cfg.setBool('settings.frpc_download_mirror', value);

  /// 镜像源格式
  String getSettingsFrpcDownloadMirrorId() =>
      cfg.getString('settings.frpc_download_mirror_id');

  void setSettingsFrpcDownloadMirrorId(String value) =>
      cfg.setString('settings.frpc_download_mirror_id', value);

  /// 已安装的 Frpc 版本
  List<String> getInstalledVersions() =>
      cfg.getStringList('lists.frpc_installed_versions');

  void addInstalledVersion(String value) {
    final List<String> list = getInstalledVersions();
    list.add(value);
    cfg.setStringList('lists.frpc_installed_versions', list.toSet().toList());
  }

  /// Frpc 下载镜像列表
  List<Map<String, dynamic>> getDownloadMirrors() {
    // 无法 cast，使用 for 转换一下类型
    final list = <Map<String, dynamic>>[];
    for (var single in cfg.getList('lists.frpc_download_mirrors')) {
      list.add(single);
    }
    return list;
  }

  void addDownloadMirror(Map<String, dynamic> value) {
    final List<Map<String, dynamic>> list = getDownloadMirrors();
    list.add(value);
    cfg.setList('lists.frpc_download_mirrors', list.toSet().toList());
  }
}
