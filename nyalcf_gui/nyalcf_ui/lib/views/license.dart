import 'package:flutter/material.dart';

import 'package:nyalcf_core_extend/utils/universe.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_ui.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 构建应用栏
      appBar: AppBar(
        // 设置应用栏标题
        title: const Text('$title - License',
            style: TextStyle(color: Colors.white)),
        // 设置应用栏操作按钮
        actions: AppbarActionsX(setting: false, context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
      ),
      // 构建首页内容区域
      body: Transform.translate(
        offset: const Offset(0, -40),
        child: LicensePage(
          applicationVersion: Universe.appVersion,
          applicationIcon: SizedBox(
            width: 48,
            child: Image.asset('icon.ico'),
          ),
        ),
      ),
      // 构建底部浮动生成按钮
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }
}
