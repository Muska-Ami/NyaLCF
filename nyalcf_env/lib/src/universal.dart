// Package imports:
import 'package:dotenv/dotenv.dart';

final _env = DotEnv(includePlatformEnvironment: true, quiet: true)..load();

String? ENV_UNIVERSAL_FRPC_PATH = _env['NYA_LCF_FRPC_PATH'];
String? ENV_UNIVERSAL_FRPC_DOWNLOAD_MIRROR_URL =
    _env['NYA_LCF_FRPC_DOWNLOAD_MIRROR_URL'];
bool? ENV_UNIVERSAL_DEBUG = bool.tryParse(
  _env['NYA_LCF_DEBUG'] ?? '',
  caseSensitive: false,
);
String? ENV_UNIVERSAL_CACHE_DIR = _env['NYA_LCF_CACHE_DIR'];
String? ENV_UNIVERSAL_SUPPORT_DIR = _env['NYA_LCF_SUPPORT_DIR'];
