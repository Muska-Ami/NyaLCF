import 'package:nyalcf_core/tasks/auto_sign.dart';
import 'package:nyalcf_core/tasks/updater.dart';

class TaskScheduler {
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
    TaskAutoSign().startUp(
      callback: () => Future.delayed(const Duration(hours: 12), () {
        TaskAutoSign().startUp();
      }),
    );
  }
}
