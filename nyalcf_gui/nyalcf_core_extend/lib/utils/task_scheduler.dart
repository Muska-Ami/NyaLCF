// Package imports:
import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_env/nyalcf_env.dart';

// Project imports:
import 'package:nyalcf_core_extend/tasks/auto_sign.dart';
import 'package:nyalcf_core_extend/tasks/update_proxies_list.dart';
import 'package:nyalcf_core_extend/tasks/updater.dart';

class TaskScheduler {
  static final _lcs = LauncherConfigurationStorage();

  static Future<void> start() async {
    if (ENV_GUI_DISABLE_AUTO_UPDATE_CHECK ?? false) _taskUpdater();
    _taskAutoSign();
    _taskUpdateProxiesList();
  }

  static _taskUpdater() async {
    TaskUpdater().startUp(
      callback: () => Future.delayed(const Duration(hours: 1), () {
        TaskUpdater().startUp();
      }),
    );
  }

  static _taskAutoSign() async {
    if (_lcs.getAutoSign()) {
      TaskAutoSign().startUp(
        callback: () => Future.delayed(const Duration(hours: 12), () {
          TaskAutoSign().startUp();
        }),
      );
    }
  }

  static _taskUpdateProxiesList() async {
    if (_lcs.getAutoSign()) {
      TaskUpdateProxiesList().startUp(
        callback: () => Future.delayed(const Duration(minutes: 15), () {
          TaskUpdateProxiesList().startUp();
        }),
      );
    }
  }
}
