// Dart imports:
import 'dart:io';

final _env = Platform.environment;

bool? ENV_GUI_DISABLE_AUTO_UPDATE_CHECK = bool.tryParse(
  _env['NYA_LCF_DISABLE_AUTO_UPDATE_CHECK'] ?? '',
  caseSensitive: false,
);
bool? ENV_GUI_DISABLE_DEEPLINK = bool.tryParse(
  _env['NYA_LCF_DISABLE_DEEPLINK'] ?? '',
  caseSensitive: false,
);
