// Package imports:
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_env/nyalcf_env.dart';

// Project imports:
import 'package:nyalcf_core_extend/tasks/auto_sign.dart';
import 'package:nyalcf_core_extend/tasks/refresh_access_token.dart';
import 'package:nyalcf_core_extend/tasks/update_proxies_list.dart';
import 'package:nyalcf_core_extend/tasks/updater.dart';

class TaskScheduler {
  static final _lcs = LauncherConfigurationStorage();

  static Future<void> start() async {
    Logger.debug("Starting tasks schedule...");
    if (ENV_GUI_DISABLE_AUTO_UPDATE_CHECK ?? false) _taskUpdater();
    _taskAutoSign();
    _taskUpdateProxiesList();
    _taskRefreshAccessToken();
    Logger.debug("Tasks started.");
  }

  static _taskUpdater() async {
    TaskUpdater().startUp(
      callback: () => Future.delayed(const Duration(hours: 1), () {
        _taskUpdater();
      }),
    );
  }

  static _taskAutoSign() async {
    if (_lcs.getAutoSign()) {
      TaskAutoSign().startUp(
        callback: () => Future.delayed(const Duration(hours: 12), () {
          _taskAutoSign();
        }),
      );
    }
  }

  static _taskRefreshAccessToken() async {
    TaskRefreshAccessToken().startUp(
      callback: () => Future.delayed(const Duration(minutes: 30), () {
        _taskRefreshAccessToken();
      }),
    );
  }

  static _taskUpdateProxiesList() async {
    if (_lcs.getAutoSign()) {
      TaskUpdateProxiesList().startUp(
        callback: () => Future.delayed(const Duration(minutes: 15), () {
          _taskUpdateProxiesList();
        }),
      );
    }
  }
}
