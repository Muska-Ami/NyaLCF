import 'package:nyalcf_core/models/process_model.dart';

class ProcessManager {
  static final List<ProcessModel> processList = [];

  static void addProcess(ProcessModel process) {
    processList.add(process);
  }
}