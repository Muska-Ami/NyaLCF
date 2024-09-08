// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:nyalcf_inject_extend/nyalcf_inject_extend.dart';

// Project imports:
import 'package:nyalcf_ui/controllers/frpc_setting_controller.dart';
import 'package:nyalcf_ui/controllers/launcher_setting_controller.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';
import 'package:nyalcf_ui/views/setting/frpc_setting.dart';
import 'package:nyalcf_ui/views/setting/launcher_setting.dart';

class SettingInjector extends StatelessWidget {
  const SettingInjector({super.key});

  @override
  Widget build(BuildContext context) {
    final FrpcSettingController fsctr =
        Get.put(FrpcSettingController(context: context));
    final DSettingLauncherController dslCtr =
        Get.put(DSettingLauncherController());
    fsctr.load();
    dslCtr.load();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('$title - 设置', style: TextStyle(color: Colors.white)),
          actions: AppbarActions(context: context, setting: false).actions(),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.launch, color: Colors.white),
                child: Text(
                  '启动器',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: Icon(Icons.support, color: Colors.white),
                child: Text(
                  'FRPC',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            LauncherSetting().widget(),
            FrpcSetting(context: context).widget()
          ],
        ),
        floatingActionButton: floatingActionButton(),
      ),
    );
  }
}
