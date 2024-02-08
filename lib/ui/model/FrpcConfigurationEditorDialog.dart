import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/ini.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:nyalcf/controllers/proxiesController.dart';
import 'package:nyalcf/controllers/userController.dart';
import 'package:nyalcf/io/frpcConfigurationStorage.dart';

class FrpcConfigEditorDialogX {
  FrpcConfigEditorDialogX({
    required this.context,
  });

  final context;

  final UserController u_c = Get.find();
  final ProxiesController p_c = Get.find();

  CodeController _controller(def_text) => CodeController(
        text: def_text,
        language: ini,
        analyzer: DefaultLocalAnalyzer(),
      );

  Widget dialog(text, {required proxy_id}) {
    final c = _controller(text);
    return AlertDialog(
      title: Text('编辑配置文件'),
      content: SizedBox(
        width: 600.0,
        child: CodeTheme(
          data: CodeThemeData(
            styles: monokaiSublimeTheme,
          ),
          child: SingleChildScrollView(
              child: CodeField(
            controller: c,
            gutterStyle: GutterStyle(
              showErrors: false,
              showLineNumbers: false,
            ),
            textStyle: TextStyle(
              fontFamily: 'Droid Sans Mono',
              fontSize: 12,
            ),
          )),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('放弃'),
          onPressed: () {
            Get.close(0);
          },
        ),
        ElevatedButton(
          child: Text('保存'),
          onPressed: () async {
            //关闭 返回true
            await FrpcConfigurationStorage.setConfig(proxy_id, c.fullText);
            p_c.reload(u_c.user, u_c.token);
            Get.close(0);
          },
        ),
      ],
    );
  }

  Widget loading() {
    return SimpleDialog(
      title: const Text('首次编辑，正在获取...'),
      children: <Widget>[
        Container(
          margin:
              EdgeInsets.only(left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: Column(
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
}
