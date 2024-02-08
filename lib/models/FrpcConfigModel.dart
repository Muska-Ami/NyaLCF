import 'package:nyalcf/utils/Logger.dart';

class FrpcConfigModel {
  FrpcConfigModel({
    required this.settings,
    required this.lists,
  });

  Map<String, dynamic> settings = Map();
  Map<String, List<String>> lists = Map();

  String get frpc_version {
    return settings['frpc_version'];
  }

  bool get github_mirror {
    Logger.debug('Mir: ${settings['github_mirror']}');
    return settings['github_mirror'];
  }

  List<String> get frpc_downloaded_versions {
    return lists['frpc_downloaded_versions'] ?? [];
  }

  List<String> get github_proxies {
    return lists['github_proxies'] ?? [];
  }

  FrpcConfigModel.fromJson(Map<String, dynamic> json)
      : settings = json['settings'],
        lists = json['lists'];

  Map<String, dynamic> toJson() => {
        'settings': settings,
        'lists': lists,
      };
}
