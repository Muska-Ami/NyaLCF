// Package imports:
import 'package:dotenv/dotenv.dart';

class Universal {
  static final _env = DotEnv(includePlatformEnvironment: true, quiet: true)
    ..load();

  String? frpcPath = _env['NYA_LCF_FRPC_PATH'];
  String? frpcDownloadMirrorUrl =
  _env['NYA_LCF_FRPC_DOWNLOAD_MIRROR_URL'];
  bool? debug = bool.tryParse(
    _env['NYA_LCF_DEBUG'] ?? '',
    caseSensitive: false,
  );
  String? cacheDir = _env['NYA_LCF_CACHE_DIR'];
  String? supportDir = _env['NYA_LCF_SUPPORT_DIR'];
  String? apiUrl = _env['NYA_LCF_API_URL'];
}