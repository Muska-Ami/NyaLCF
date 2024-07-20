import 'package:nyalcf_core/models/process_model.dart';

class ProcessManager {
  static final List<ProcessModel> processList = [];

  /// 添加进程
  static void addProcess(ProcessModel process) {
    processList.add(process);
  }

  /// 添加进程
  static void removeProcess(ProcessModel process) {
    processList.remove(process);
  }

}