import 'package:nyalcf_core/storages/configurations/launcher_configuration_storage.dart';
import 'package:nyalcf_core/tasks/auto_sign.dart';
import 'package:nyalcf_core/tasks/updater.dart';

class TaskScheduler {
  static final _lcs = LauncherConfigurationStorage();

  static Future<void> start() async {
    _taskUpdater();
    _taskAutoSign();
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
}
