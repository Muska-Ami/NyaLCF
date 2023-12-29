import 'package:nyalcf/model/FrpcConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPrefs {
  static Future<void> setFrpcInfo(FrpcConfig frpcinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('setting@frpc_version', frpcinfo.frpc_version);
    prefs.setStringList('list@frpc_downloaded_versions', frpcinfo.frpc_downloaded_versions);
    prefs.setString('setting@github_proxy', frpcinfo.github_proxy);
    prefs.setStringList('list@github_proxies', frpcinfo.github_proxies);
  }
  static Future<FrpcConfig> getFrpcInfo(FrpcConfig frpcinfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final s_frpc_version = prefs.getString('setting@frpc_version') ?? '';
    final l_frpc_downloaded_versions = prefs.getStringList('list@frpc_downloaded_versions') ?? [];
    final s_github_proxy = prefs.getString('setting@github_proxy') ?? '';
    final l_github_proxies = prefs.getStringList('list@github_proxies') ?? [];

    final Map<String, dynamic> settings = Map();
    settings['frpc_version'] = s_frpc_version;
    settings['github_proxy'] = s_github_proxy;

    final Map<String, List<String>> lists = Map();
    lists['frpc_downloaded_versions'] = l_frpc_downloaded_versions;
    lists['github_proxies'] = l_github_proxies;

    return FrpcConfig(settings: settings, lists: lists);
  }
}