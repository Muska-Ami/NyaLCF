import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/io/frpcManagerStorage.dart';
import 'package:nyalcf/util/FileIO.dart';

class FrpcController extends GetxController {
  final _support_path = FileIO.support_path;
  var exist = false.obs;
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
  var version = ''.obs;

  load() async {
    exist.value = await file.exists();
  }

  /// 获取Frpc文件对象
  get file => FrpcManagerStorage.getFile(version.value);

  Future<String> getVersion() async {
    String path = await _support_path + '/setting/frpc.json';
    final setting = File(path).readAsString();
    final Map<String, dynamic> settingJson = jsonDecode(await setting);
    return settingJson['use_version'];
  }

  void appendInfoLog(element) {
    if (process_out.length >= 500) process_out.remove(process_out.first);
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
    process_out.refresh();
  }

  void appendWarnLog(element) {
    if (process_out.length >= 500) process_out.remove(process_out.first);
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
    process_out.refresh();
  }

  void appendErrorLog(element) {
    if (process_out.length >= 500) process_out.remove(process_out.first);
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
    process_out.refresh();
  }
}