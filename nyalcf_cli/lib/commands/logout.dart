// Package imports:

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:nyalcf_core/storages/stores/user_info_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';

// Project imports:
import 'package:nyalcf/templates/command.dart';

class Logout implements Command {
  @override
  Future<void> main(List<String> args) async {
    await UserInfoStorage.logout();
    Logger.info('Session data removed.');
    exit(0);
  }
}
