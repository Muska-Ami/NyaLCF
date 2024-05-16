import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/frpc_configuration_storage.dart';
import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

class FrpcController extends GetxController {
  final fss = FrpcStorage();
  final FrpcConfigurationStorage fcs = FrpcConfigurationStorage();

  /// 是否存在的标志
  RxBool exist = false.obs;

  /// 过滤后的输出文本
  RxList<SelectableText> processOut = <SelectableText>[
    const SelectableText(
      '[SYSTEM] Welcome to frpc console.',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w200,
        fontFamily: 'Droid Sans Mono',
      ),
    )
  ].obs;

  /// 版本号
  RxString version = ''.obs;

  // String? get customPath => Platform.environment['NYA_LCF_FRPC_PATH'];

  /// 加载方法
  load() async {
    exist.value = await file.exists();
  }

  /// 获取Frpc文件对象
  get file => fss.getFile();

  /// 获取版本号
  Future<String> getVersion() async {
    return fcs.getSettingsFrpcVersion();
  }

  /// 追加信息日志
  void appendInfoLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加信息日志文本
    processOut.add(
      SelectableText(
        '[FRPC][INFO] $element',
        style: const TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加警告日志
  void appendWarnLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加警告日志文本
    processOut.add(
      SelectableText(
        '[FRPC][WARN] $element',
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  /// 追加错误日志
  void appendErrorLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加错误日志文本
    processOut.add(
      SelectableText(
        '[FRPC][ERROR] $element',
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  void appendSystemInfoLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加警告日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][INFO] $element',
        style: TextStyle(
          color: Colors.tealAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  void appendSystemWarnLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加信息日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][WARN] $element',
        style: TextStyle(
          color: Colors.orangeAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }

  void appendSystemErrorLog(String element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (processOut.length >= 500) processOut.remove(processOut.first);

    /// 添加错误日志文本
    processOut.add(
      SelectableText(
        '[SYSTEM][ERROR] $element',
        style: TextStyle(
          color: Colors.redAccent[400],
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    processOut.refresh();
  }
}
