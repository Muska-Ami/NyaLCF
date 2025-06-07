// Package imports:
import 'package:dotenv/dotenv.dart';

class GUI {
  static final _env = DotEnv(includePlatformEnvironment: true, quiet: true)
    ..load();

  bool? disableAutoUpdateCheck = bool.tryParse(
    _env['NYA_LCF_GUI_DISABLE_AUTO_UPDATE_CHECK'] ?? '',
    caseSensitive: false,
  );
  bool? disableDeeplink = bool.tryParse(
    _env['NYA_LCF_GUI_DISABLE_DEEPLINK'] ?? '',
    caseSensitive: false,
  );
}