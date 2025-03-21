// Dart imports:
import 'dart:io';

// Package imports:
import 'package:win32_registry/win32_registry.dart';

class DeepLinkRegister {
  /// 在 Windows 上注册 DeepLink
  static Future<void> registerWindows(String scheme) async {
    String appPath = Platform.resolvedExecutable;

    String path = 'Software\\Classes';
    final defPath = Registry.openPath(
      RegistryHive.currentUser,
      path: path,
      desiredAccessRights: AccessRights.allAccess,
    );
    defPath.createKey(scheme);
    defPath.close();

    final protocolPath = Registry.openPath(
      RegistryHive.currentUser,
      path: '$path\\$scheme',
      desiredAccessRights: AccessRights.allAccess,
    );
    protocolPath.createValue(RegistryValue.string('URL Protocol', ''));
    protocolPath.createValue(RegistryValue.string('Default', 'URL:$scheme Protocol'));
    protocolPath.close();

    final cmdKey = Registry.openPath(
      RegistryHive.currentUser,
      path: '$path\\$scheme\\shell\\open\\command',
      desiredAccessRights: AccessRights.allAccess,
    );
    cmdKey.createValue(RegistryValue.string('', '"$appPath" "%1"'));
    cmdKey.close();
  }
}

