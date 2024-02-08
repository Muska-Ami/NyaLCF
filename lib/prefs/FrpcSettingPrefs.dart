import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/models/FrpcConfigModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrpcSettingPrefs {
  static Future<void> setFrpcInfo(FrpcConfigModel frpcinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('frpc@setting@frpc_version', frpcinfo.frpc_version);
    prefs.setStringList('frpc@list@frpc_downloaded_versions',
        frpcinfo.frpc_downloaded_versions);
    prefs.setBool('frpc@setting@github_mirror', frpcinfo.github_mirror);
    prefs.setStringList('frpc@list@github_proxies', frpcinfo.github_proxies);
  }

  static Future<void> setFrpcDownloadedVersionsInfo(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newlist =
        (await getFrpcInfo()).lists['frpc_downloaded_versions'] ?? [];
    newlist.add(version);
    prefs.setStringList(
        'frpc@list@frpc_downloaded_versions', newlist.toSet().toList());
  }

  static Future<void> setDownloadUseMirror(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('frpc@setting@github_mirror', value);
  }

  static Future<FrpcConfigModel> getFrpcInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final s_frpc_version = prefs.getString('frpc@setting@frpc_version') ?? '';
    final l_frpc_downloaded_versions =
        prefs.getStringList('frpc@list@frpc_downloaded_versions') ?? [];
    final s_github_mirror = prefs.getBool('frpc@setting@github_mirror') ?? true;
    final l_github_proxies =
        prefs.getStringList('frpc@list@github_proxies') ?? [];

    final Map<String, dynamic> settings = Map();
    settings['frpc_version'] = s_frpc_version;
    settings['github_mirror'] = s_github_mirror;

    final Map<String, List<String>> lists = Map();
    lists['frpc_downloaded_versions'] = l_frpc_downloaded_versions;
    lists['github_proxies'] = l_github_proxies;

    return FrpcConfigModel(settings: settings, lists: lists);
  }

  static Future<void> refresh() async {
    final res = await FrpcManagerStorage.read();
    if (res != null) setFrpcInfo(res);
  }
}
