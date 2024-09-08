// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/storages/configurations/proxies_configuration_storage.dart';
import 'package:nyalcf_core_extend/utils/highlight/ini_fix.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/proxies_controller.dart';
import 'package:nyalcf_ui/controllers/user_controller.dart';

final UserController _uCtr = Get.find();
final ProxiesController _pCtr = Get.find();

CodeController _controller(defText) => CodeController(
      text: defText,
      language: ini,
      analyzer: const DefaultLocalAnalyzer(),
    );

Widget frpcConfigurationEditorDialog(BuildContext context, text,
    {required proxyId}) {
  final c = _controller(text);
  return AlertDialog(
    title: const Text('编辑配置文件'),
    content: SizedBox(
      width: 600.0,
      child: CodeTheme(
        data: CodeThemeData(
          styles: monokaiSublimeTheme,
        ),
        child: SingleChildScrollView(
            child: CodeField(
          controller: c,
          gutterStyle: GutterStyle.none,
          textStyle: const TextStyle(
            fontFamily: 'Droid Sans Mono',
            fontSize: 12,
          ),
        )),
      ),
    ),
    actions: <Widget>[
      ElevatedButton(
        child: const Text('放弃'),
        onPressed: () {
          Get.close(0);
        },
      ),
      ElevatedButton(
        child: const Text('保存'),
        onPressed: () async {
          //关闭 返回true
          await ProxiesConfigurationStorage.setConfig(proxyId, c.fullText);
          _pCtr.load(_uCtr.user, _uCtr.token);
          Get.close(0);
        },
      ),
    ],
  );
}

Widget frpcConfigurationEditorLoadingDialog() {
  return SimpleDialog(
    title: const Text('首次编辑，正在获取...'),
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only(
            left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
        child: const Column(
          children: <Widget>[
            SizedBox(
              height: 22.0,
              width: 22.0,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
