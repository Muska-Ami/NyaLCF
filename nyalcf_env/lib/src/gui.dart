// Package imports:
import 'package:dotenv/dotenv.dart';

final _env = DotEnv(includePlatformEnvironment: true)..load();

bool? ENV_GUI_DISABLE_AUTO_UPDATE_CHECK = bool.tryParse(
  _env['NYA_LCF_GUI_DISABLE_AUTO_UPDATE_CHECK'] ?? '',
  caseSensitive: false,
);
bool? ENV_GUI_DISABLE_DEEPLINK = bool.tryParse(
  _env['NYA_LCF_GUI_DISABLE_DEEPLINK'] ?? '',
  caseSensitive: false,
);
