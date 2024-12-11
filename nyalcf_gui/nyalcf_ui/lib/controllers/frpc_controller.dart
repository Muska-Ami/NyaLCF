// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_core/models/process_model.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

// Project imports:
import 'package:nyalcf_ui/views/panel/console.dart';

class FrpcController extends GetxController {
  final _fss = FrpcStorage();
  final FrpcConfigurationStorage _fcs = FrpcConfigurationStorage();

  // /// 是否存在的标志
  // RxBool exists = false.obs;

  /// 版本号
  RxString version = ''.obs;

  /// 进程列表
  static var processList = <ProcessModel>[].obs;

  // String? get customPath => Platform.environment['NYA_LCF_FRPC_PATH'];

  // /// 加载方法
  // load() async {
    // exists.value = await ((await file)?.exists()) ?? false;
  // }

  /// 获取Frpc文件对象
  get file => _fss.getFile();

  /// 获取版本号
  Future<String> getVersion() async {
    return _fcs.getSettingsFrpcVersion();
  }

  /// 添加进程
  /// [process] 进程模型
  void addProcess(ProcessModel process) {
    processList.add(process);
    processList.refresh();
    ConsolePanelUI.buildProcessListWidget();
  }

  /// 移除进程
  /// [process] 进程模型
  void removeProcess(ProcessModel process) {
    processList.remove(process);
    processList.refresh();
    ConsolePanelUI.buildProcessListWidget();
  }

  /// 清空进程
  /// 请将进程全部结束后再运行此方法，此方法不会结束进程
  void clearProcess() {
    processList.clear();
    processList.refresh();
    // load();
    ConsolePanelUI.buildProcessListWidget();
  }
}
