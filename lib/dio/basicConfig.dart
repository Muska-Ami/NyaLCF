import 'package:nyalcf/io/frpcManagerStorage.dart';

class basicConfig {
  static final api_v1_url = 'https://api.locyanfrp.cn';
  static final api_v2_url = 'https://api-v2.locyanfrp.cn/api/v2';
  static final github_api_url = 'https://api.github.com';
  static final github_main_url = 'https://github.com';
  static final github_main_proxy_url_list = <String>[
    'https://ghproxy.com',
    'https://mirror.ghproxy.com',
  ].addAll(FrpcManagerStorage.proxies);
  static final frpc_release_repo = 'LoCyan-Team/LoCyanFrpPureApp';
}
