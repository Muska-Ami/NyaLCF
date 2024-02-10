import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/storages/configurations/FrpcConfigurationStorage.dart';
import 'package:nyalcf/storages/stories/FrpcStoryStorage.dart';

class FrpcController extends GetxController {
  final fcs = FrpcConfigurationStorage();

  /// 是否存在的标志
  var exist = false.obs;

  /// 过滤后的输出文本
  var process_out = <SelectableText>[
    SelectableText(
      '[SYSTEM] Welcome to frpc console.',
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w200,
        fontFamily: 'Droid Sans Mono',
      ),
    )
  ].obs;

  /// 版本号
  var version = ''.obs;

  String? get custom_path => Platform.environment['NYA_LCF_FRPC_PATH'];

  /// 加载方法
  load() async {
    exist.value = await file.exists();
  }

  /// 获取Frpc文件对象
  get file => FrpcStoryStorage.getFile();

  /// 获取版本号
  Future<String> getVersion() async {
    return fcs.getSettingsFrpcVersion();
  }

  /// 追加信息日志
  void appendInfoLog(element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (process_out.length >= 500) process_out.remove(process_out.first);

    /// 添加信息日志文本
    process_out.add(
      SelectableText(
        '[FRPC][INFO] $element',
        style: TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    process_out.refresh();
  }

  /// 追加警告日志
  void appendWarnLog(element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (process_out.length >= 500) process_out.remove(process_out.first);

    /// 添加警告日志文本
    process_out.add(
      SelectableText(
        '[FRPC][WARN] $element',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    process_out.refresh();
  }

  /// 追加错误日志
  void appendErrorLog(element) {
    /// 如果输出文本长度超过500，则移除第一条文本
    if (process_out.length >= 500) process_out.remove(process_out.first);

    /// 添加错误日志文本
    process_out.add(
      SelectableText(
        '[FRPC][ERROR] $element',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w200,
          fontFamily: 'Droid Sans Mono',
        ),
      ),
    );

    /// 刷新输出文本
    process_out.refresh();
  }
}
